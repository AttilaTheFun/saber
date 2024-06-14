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
        for injectProperty in visitor.injectProperties {
            let protocolProperty = "var \(injectProperty.label): \(injectProperty.typeDescription.asSource) { get }"
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
        let initializerDeclaractions = [
            try self.initializerDeclaration(visitor: visitor, declaration: declaration)
        ] + self.requiredInitializers()

        return propertyDeclarations + initializerDeclaractions
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
        private let dependencies: any \(raw: concreteDeclaration.name.trimmed)Dependencies
        """
        propertyDeclarations.append(dependenciesPropertyDeclaration)

        // Create the factory computed properties:
//        for (property, attributeSyntax) in visitor.factoryProperties {
//            let (propertyName, existentialType, concreteType, argumentsType) = try self.computedPropertyTypes(
//                property: property,
//                attributeSyntax: attributeSyntax
//            )
//
//            // Determine the arguments clause:
//            let argumentsClause = argumentsType == nil ? "" : "arguments: arguments"
//            let argumentsClauseWithComma = argumentsClause.isEmpty ? "" : argumentsClause + ", "
//
//            // Create the factory lines:
//            let factoryLines: [String]
//            if let factoryKeyPathArgument = attributeSyntax.factoryKeyPathArgument {
//                factoryLines = [
//                    "let scope = \(concreteType)(\(argumentsClauseWithComma)dependencies: self)",
//                    "return scope.\(factoryKeyPathArgument).build(\(argumentsClause))"
//                ]
//            } else {
//                factoryLines = [
//                    "\(concreteType)(\(argumentsClauseWithComma)dependencies: self)"
//                ]
//            }
//
//            // Create the property declaration:
//            let accessLevel = concreteDeclaration.modifiers.accessLevel
//            let factoryGenericType = "<\(argumentsType ?? "Void"), \(existentialType)>"
//            let propertyDeclaration: DeclSyntax =
//            """
//            \(raw: accessLevel) var \(raw: propertyName)Factory: any Factory\(raw: factoryGenericType) {
//                FactoryImplementation\(raw: factoryGenericType) { arguments in
//                    \(raw: factoryLines.joined(separator: "        \n"))
//                }
//            }
//            """
//
//            propertyDeclarations.append(propertyDeclaration)
//        }

        return propertyDeclarations
    }

    private static func computedPropertyTypes(
        property: Property,
        attributeSyntax: AttributeSyntax
    ) throws -> (
        propertyName: String,
        existentialType: String,
        concreteType: String
    ) {

        // Determine the property name:
        let typeSuffix = "Type"
        guard property.label.hasSuffix(typeSuffix) else {
            throw InjectableMacroProtocolError.invalidComputedPropertyName
        }
        let propertyName = String(property.label.dropLast(typeSuffix.count))

        // Determine the existential type:
        guard case let .metatype(description, isType) = property.typeDescription, isType else {
            throw InjectableMacroProtocolError.invalidComputedPropertyType
        }
        let existentialType = description.asSource

        // Determine the concrete type:
        guard let concreteTypeDescription = attributeSyntax.concreteTypeArgument else {
            // TODO: Diagnostic
            fatalError()
        }
        let concreteType = concreteTypeDescription.asSource

        return (propertyName, existentialType, concreteType)
    }

    private static func initializerDeclaration(
        visitor: InjectableVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> DeclSyntax {
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
        initializerLines.append("self.dependencies = dependencies")

        // Add an initializer line for each @Inject property:
        for property in visitor.injectProperties {
            initializerLines.append("self.\(property.label) = dependencies.\(property.label)")
        }

        // Add the superclass initializer, if necessary:
        if let superclassInitializer = self.superclassInitializerLine() {
            initializerLines.append(superclassInitializer)
        }

        // Add lines to the initializer to eagerly initialize store properties with this argument:
        for (property, attributeSyntax) in visitor.storeProperties {
            guard attributeSyntax.initializationStrategyArgument == .eager else {
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

        return initializerDeclaration
    }
}
