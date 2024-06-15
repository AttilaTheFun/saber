import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum InjectableMacroProtocolError: Error {
    case declarationNotConcrete
    case invalidMacroArguments
    case invalidComputedPropertyName
    case invalidComputedPropertyType
}

public protocol InjectableMacroProtocol: MemberMacro, PeerMacro {
    static func superclassInitializerLine() -> String?
    static func requiredInitializers() -> [DeclSyntax]
}

extension InjectableMacroProtocol {

    // MARK: Initializers

    /// The superclass initializer to call, if any.
    public static func superclassInitializerLine() -> String? {
        return nil
    }

    /// The additional, required initializer implementations, if any.
    public static func requiredInitializers() -> [DeclSyntax] {
        return []
    }

    // MARK: PeerMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        // Walk the declaration with the visitor:
        let visitor = InjectableVisitor()
        visitor.walk(declaration)

        // Create the protocol declarations:
        let declarations: [DeclSyntax?] = [
            try self.dependenciesProtocolDeclaration(
                visitor: visitor,
                declaration: declaration
            ),
            try self.childDependenciesProtocolDeclaration(
                visitor: visitor,
                declaration: declaration
            )
        ]

        return declarations.compactMap { $0 }
    }

    private static func dependenciesProtocolDeclaration(
        visitor: InjectableVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> DeclSyntax? {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw InjectableMacroProtocolError.declarationNotConcrete
        }

        // Create properties for the protocol:
        var protocolProperties = [String]()
        for (property, _) in visitor.injectProperties {
            let protocolProperty = "var \(property.label): \(property.typeDescription.asSource) { get }"
            protocolProperties.append(protocolProperty)
        }
        let protocolBody = protocolProperties.joined(separator: "\n")

        // Create the child dependencies protocol declaration:
        let dependenciesProtocolName = "\(concreteDeclaration.name.trimmed)Dependencies"
        let dependenciesProtocolDeclaration: DeclSyntax =
        """
        \(raw: concreteDeclaration.modifiers.accessLevel) protocol \(raw: dependenciesProtocolName) {
        \(raw: protocolBody)
        }
        """

        return dependenciesProtocolDeclaration
    }

    private static func childDependenciesProtocolDeclaration(
        visitor: InjectableVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> DeclSyntax? {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw InjectableMacroProtocolError.declarationNotConcrete
        }

        // Use the visitor to collect the @Store and @Factory properties:
        let propertiesWithChildDependencies = visitor.storeProperties + visitor.factoryProperties
        guard propertiesWithChildDependencies.count > 0 else {
            return nil
        }

        // Extract the concrete type descriptions from the @Store and @Factory arguments:
        var concreteTypeDescriptions = [TypeDescription]()
        for (_, attributeSyntax) in propertiesWithChildDependencies {
            guard let concreteTypeDescription = attributeSyntax.concreteTypeArgument else {
                // TODO: Diagnostic
                fatalError()
            }

            concreteTypeDescriptions.append(concreteTypeDescription)
        }

        // Create the child dependencies protocol declaration:
        let childDependenciesProtocolNames = concreteTypeDescriptions
            .map { $0.asSource + "Dependencies" }
            .sorted()
        let inheritanceClause = childDependenciesProtocolNames.joined(separator: "\n    & ")
        let childDependenciesProtocolName = "\(concreteDeclaration.name.trimmed)ChildDependencies"
        let childDependenciesProtocolDeclaration: DeclSyntax =
        """
        \(raw: concreteDeclaration.modifiers.accessLevel) protocol \(raw: childDependenciesProtocolName)
            : \(raw: inheritanceClause)
        {}
        """

        return childDependenciesProtocolDeclaration
    }

    // MARK: MemberMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext) throws
        -> [DeclSyntax]
    {
        // Walk the declaration with the visitor:
        let visitor = InjectableVisitor()
        visitor.walk(declaration)

        // Create the declarations:
        let propertyDeclarations = try self.propertyDeclarations(visitor: visitor, declaration: declaration)
        let initializerDeclarations = try self.initializerDeclarations(visitor: visitor, declaration: declaration)

        return propertyDeclarations + initializerDeclarations
    }

    private static func propertyDeclarations(
        visitor: InjectableVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> [DeclSyntax] {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw InjectableMacroProtocolError.declarationNotConcrete
        }

        // Create the property declarations:
        var propertyDeclarations = [DeclSyntax]()

        // Create the dependencies property declaration:
        let dependenciesPropertyDeclaration: DeclSyntax =
        """
        private let _dependencies: any \(raw: concreteDeclaration.name.trimmed)Dependencies
        """
        propertyDeclarations.append(dependenciesPropertyDeclaration)

        // Create the stored property declarations:
        for (property, attributeSyntax) in visitor.storeProperties {

            // If this is a purely computed property, we don't need a backing stored property.
            if case .computed = attributeSyntax.accessStrategyArgument ?? .strong {
                continue
            }

            // Create the stored property declaration:
            let storedPropertyType: TypeDescription = .optional(property.typeDescription)
            let storedPropertyDeclaration: DeclSyntax =
            """
            private var _\(raw: property.label): \(raw: storedPropertyType.asSource)
            """
            propertyDeclarations.append(storedPropertyDeclaration)

            // If thread safe, create the lock stored property declaration:
            if case .safe = attributeSyntax.threadSafetyStrategyArgument {
                let lockStoredPropertyDeclaration: DeclSyntax =
                """
                private var _\(raw: property.label)Lock = Lock()
                """
                propertyDeclarations.append(lockStoredPropertyDeclaration)
            }
        }

        // Create the stored property declarations:
        for (property, attributeSyntax) in visitor.injectProperties {

            // If this is a purely computed property, we don't need a backing stored property.
            if case .computed = attributeSyntax.accessStrategyArgument ?? .computed {
                continue
            }

            // Create the stored property declaration:
            let storedPropertyType: TypeDescription = .optional(property.typeDescription)
            let storedPropertyDeclaration: DeclSyntax =
            """
            private var _\(raw: property.label): \(raw: storedPropertyType.asSource)
            """
            propertyDeclarations.append(storedPropertyDeclaration)
        }

        return propertyDeclarations
    }

    private static func initializerDeclarations(
        visitor: InjectableVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> [DeclSyntax] {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw InjectableMacroProtocolError.declarationNotConcrete
        }

        // Create the initializer arguments:
        var initializerArguments = [String]()
        if let argumentsProperty = visitor.argumentsProperty {
            initializerArguments.append("arguments: \(argumentsProperty.typeDescription.asSource)")
        }
        initializerArguments.append("dependencies: any \(concreteDeclaration.name.trimmed)Dependencies")

        // Create the initializer lines:
        var initializerLines = [String]()
        if let argumentsProperty = visitor.argumentsProperty {
            initializerLines.append("self.\(argumentsProperty.label) = arguments")
        }
        initializerLines.append("self._dependencies = dependencies")

        // Add the superclass initializer, if necessary:
        var requiredInitializers = [DeclSyntax]()
        if
            let inheritanceClause = concreteDeclaration.inheritanceClause,
            let inheritedType = try inheritanceClause.inheritedTypes.first.map(InheritedTypeSyntax.init),
            case .simple(let name, _) = inheritedType.type.typeDescription,
            name.hasSuffix("ViewController")
        {
            initializerLines.append("super.init(nibName: nil, bundle: nil)")
            requiredInitializers = [
                """
                required init?(coder: NSCoder) {
                    fatalError("not implemented")
                }
                """
            ]
        }

        // Add lines to the initializer to eagerly initialize store properties with this argument:
        let storedProperties = visitor.storeProperties + visitor.injectProperties
        for (property, attributeSyntax) in storedProperties {
            guard case .eager = attributeSyntax.initializationStrategyArgument else {
                continue
            }

            initializerLines.append("_ = self.\(property.label)")
        }

        // Create the initializer:
        let initializerDeclaration: DeclSyntax =
        """
        \(raw: concreteDeclaration.modifiers.accessLevel) init(
        \(raw: initializerArguments.joined(separator: ",\n"))
        ) {
        \(raw: initializerLines.joined(separator: "\n"))
        }
        """

        return [initializerDeclaration] + requiredInitializers
    }
}
