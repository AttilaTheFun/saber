import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

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
        let visitor = InjectableVisitor()
        visitor.walk(declaration)

        // Create properties for the protocol:
        var protocolProperties = [String]()
        for injectedProperty in visitor.injectedProperties {
            let protocolProperty = "var \(injectedProperty.label): \(injectedProperty.typeDescription.asSource) { get }"
            protocolProperties.append(protocolProperty)
        }
        let protocolBody = protocolProperties.joined(separator: "\n")

        // TODO: Parse just the access level from the nominal type and apply it to the initializer.
        // For now we default to public.
        // nominalType.modifiers.trimmed
        let nominalTypeAccessLevel = "public"

        // Create the dependencies protocol declaration:
        let nominalType = try Parsers.parseNominalTypeSyntax(declaration: declaration)
        let typeName = nominalType.name.text
        let dependenciesProtocolName = "\(typeName)Dependencies"
        let dependenciesProtocolDeclaration: DeclSyntax =
        """
        \(raw: nominalTypeAccessLevel) protocol \(raw: dependenciesProtocolName) {
        \(raw: protocolBody)
        }
        """
        var declarations: [DeclSyntax] = [
            dependenciesProtocolDeclaration
        ]

        // If there are any instantiated dependencies, create the child dependencies protocol declaration.
        if visitor.initializedProperties.count > 0 {
            var instantiatedConcreteTypeDescriptions = [TypeDescription]()
            for (_, attributeSyntax) in visitor.initializedProperties {
                guard let concreteTypeDescription = attributeSyntax.concreteTypeArgument else {
                    // TODO: Diagnostic
                    fatalError()
                }

                instantiatedConcreteTypeDescriptions.append(concreteTypeDescription)
            }

            let childDependenciesProtocolNames = instantiatedConcreteTypeDescriptions
                .map { $0.asSource + "Dependencies" }
                .sorted()
            let inheritanceClause = childDependenciesProtocolNames.joined(separator: "\n    & ")
            let childDependenciesProtocolDeclaration: DeclSyntax =
            """
            \(raw: nominalTypeAccessLevel) protocol \(raw: typeName)ChildDependencies
                : \(raw: inheritanceClause)
            {}
            """
            declarations.append(childDependenciesProtocolDeclaration)
        }

        return declarations
    }

    // MARK: MemberMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext) throws
        -> [DeclSyntax]
    {
        // Parse the nominal type:
        let nominalType = try Parsers.parseNominalTypeSyntax(declaration: declaration) // TODO: Use TypeDescription
        let typeName = nominalType.name.text

        // Parse the properties:
        let visitor = InjectableVisitor()
        visitor.walk(declaration)

        // Create the initializer arguments:
        var initializerArguments = [String]()
        var initializerLines = [String]()
        if let argumentsProperty = visitor.argumentsProperty {
            initializerArguments.append("arguments: \(argumentsProperty.typeDescription.asSource)")
            initializerLines.append("self.\(argumentsProperty.label) = arguments")
        }
        initializerArguments.append("dependencies: any \(typeName)Dependencies")
        initializerLines.append("self.dependencies = dependencies")
        for injectedProperty in visitor.injectedProperties {
            initializerLines.append("self.\(injectedProperty.label) = dependencies.\(injectedProperty.label)")
        }
        for (initializedProperty, attributeSyntax) in visitor.initializedProperties {
            guard let concreteTypeDescription = attributeSyntax.concreteTypeArgument else {
                // TODO: Diagnostic
                fatalError()
            }

            initializerLines.append("self.\(initializedProperty.label) = \(concreteTypeDescription.asSource).self")
        }
        if let superclassInitializer = self.superclassInitializerLine() {
            initializerLines.append(superclassInitializer)
        }

        // TODO: Parse just the access level from the nominal type and apply it to the initializer.
        // For now we default to public.
        // nominalType.modifiers.trimmed
        let nominalTypeAccessLevel = "public"

        // Create the initializer:
        let initializerDeclaration: DeclSyntax =
        """
        \(raw: nominalTypeAccessLevel) init(
        \(raw: initializerArguments.joined(separator: ",\n"))
        ) {
        \(raw: initializerLines.joined(separator: "\n"))
        }
        """

        // Create the declarations:
        var propertyDeclarations = [DeclSyntax]()
        let initializerDeclaractions = [initializerDeclaration] + self.requiredInitializers()
        var functionDeclarations = [DeclSyntax]()

        // Create the dependencies property:
        let dependenciesPropertyDeclaration: DeclSyntax =
        """
        private let dependencies: any \(raw: typeName)Dependencies
        """
        propertyDeclarations.append(dependenciesPropertyDeclaration)

        // Create the initializer computed properties:
        for (initializedProperty, attributeSyntax) in visitor.initializedProperties {

            // Determine the property name:
            let typeSuffix = "Type"
            var propertyName = initializedProperty.label
            if propertyName.hasSuffix(typeSuffix) {
                propertyName = String(propertyName.dropLast(typeSuffix.count)).uppercasedFirstCharacter()
            } else {
                // TODO: Diagnostic
                fatalError()
            }

            // Determine the property type:
            guard case let .metatype(description, isType) = initializedProperty.typeDescription, isType else {
                // TODO: Diagnostic
                fatalError()
            }

            // Determine the concrete type:
            guard let concreteTypeDescription = attributeSyntax.concreteTypeArgument else {
                // TODO: Diagnostic
                fatalError()
            }

            // Parse the arguments type if provided:
            var argumentsClause = ""
            var propagatedArguments = ""
            if let argumentsTypeDescription = attributeSyntax.argumentsTypeArgument {
                argumentsClause = "arguments: " + argumentsTypeDescription.asSource
                propagatedArguments = "arguments: arguments, "
            }

            let initializerFunctionDeclaration: DeclSyntax =
            """
            private func initialize\(raw: propertyName)(\(raw: argumentsClause)) -> any \(raw: description.asSource) {
            return \(raw: concreteTypeDescription.asSource)(\(raw: propagatedArguments)dependencies: self)
            }
            """
            functionDeclarations.append(initializerFunctionDeclaration)
        }

        return propertyDeclarations + initializerDeclaractions + functionDeclarations
    }
}
