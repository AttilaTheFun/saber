import SaberTypes
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum InjectableMacroProtocolError: Error {
    case declarationNotConcrete
    case invalidMacroArguments
    case invalidComputedPropertyName
    case invalidComputedPropertyType
}

public protocol InjectableMacroProtocol: ExtensionMacro, MemberMacro, PeerMacro {}

extension InjectableMacroProtocol {

    // MARK: ExtensionMacro

    public static func expansion(
      of node: AttributeSyntax,
      attachedTo declaration: some DeclGroupSyntax,
      providingExtensionsOf type: some TypeSyntaxProtocol,
      conformingTo protocols: [TypeSyntax],
      in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {

        // Walk the declaration with the visitor:
        let visitor = DeclarationVisitor()
        visitor.walk(declaration)
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw InjectableMacroProtocolError.declarationNotConcrete
        }

        // If this type is also annotated with the @Scope macro, defer to its protocol conformance:
        guard concreteDeclaration.attributes.scopeMacro == nil else {
            return []
        }

        // Create the extension declaration:
        let extensionDeclaration = try self.extensionDeclaration(
            declaration: declaration,
            type: type
        )

        return [extensionDeclaration]
    }

    private static func extensionDeclaration(
        declaration: some DeclGroupSyntax,
        type: some TypeSyntaxProtocol
    ) throws -> ExtensionDeclSyntax {

        // Create the member block:
        let memberBlockItemList = MemberBlockItemListSyntax([])
        let memberBlock = MemberBlockSyntax(members: memberBlockItemList)

        // Create the extension declaration:
        let inheritedProtocolType = TypeSyntax(stringLiteral: "Injectable")
        let inheritedType = InheritedTypeSyntax(type: inheritedProtocolType)
        let inheritedTypeList = InheritedTypeListSyntax([inheritedType])
        let inheritanceClause = InheritanceClauseSyntax(inheritedTypes: inheritedTypeList)
        let extensionDeclaration = ExtensionDeclSyntax(
            extendedType: type,
            inheritanceClause: inheritanceClause,
            memberBlock: memberBlock
        )

        return extensionDeclaration
    }

    // MARK: MemberMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax]
    {
        // Walk the declaration with the visitor:
        let visitor = DeclarationVisitor()
        visitor.walk(declaration)

        // Create the member declarations:
        var memberDeclarations = [DeclSyntax]()
        memberDeclarations += try self.parentTypeAliasDeclarations(
            node: node,
            visitor: visitor,
            declaration: declaration
        )
        memberDeclarations += try self.parentPropertyDeclarations(
            node: node,
            visitor: visitor,
            declaration: declaration
        )

        // If the initializer was not handwritten, we should generate it:
        let shouldGenerateInitializers = visitor.initArgumentsAndDependenciesDeclaration == nil
        if shouldGenerateInitializers {
            memberDeclarations += try self.parentInitializerDeclarations(
                node: node,
                visitor: visitor,
                declaration: declaration
            )
        }

        return memberDeclarations
    }

    private static func parentTypeAliasDeclarations(
        node: AttributeSyntax,
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> [DeclSyntax] {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw InjectableMacroProtocolError.declarationNotConcrete
        }

        var typeAliasDeclarations = [DeclSyntax]()

        // If there is not a handwritten arguments type alias declaration, we need to create one:
        if visitor.argumentsTypeAliasDeclaration == nil {

            // Determine the arguments type:
            let argumentsType: String
            if visitor.argumentProperties.count > 0 {
                // If we have argument properties,
                // we infer the Arguments type name is the concrete type name with the Arguments suffix.
                argumentsType = "\(concreteDeclaration.name.trimmed)Arguments"
            } else {
                // If there are no argument properties,
                // we infer the Arguments type to be Void.
                argumentsType = "Void"
            }

            // Create the arguments type alias declaration:
            let accessLevel = concreteDeclaration.modifiers.accessLevel.rawValue
            let argumentsTypeAliasDeclaration: DeclSyntax =
            """
            \(raw: accessLevel) typealias Arguments = \(raw: argumentsType)
            """
            typeAliasDeclarations.append(argumentsTypeAliasDeclaration)
        }

        // If there is not a handwritten dependencies type alias declaration, we need to create one:
        if visitor.dependenciesTypeAliasDeclaration == nil {
            let dependenciesSuffix = (node.dependenciesReferenceTypeArgument ?? .strong) == .unowned ?
                "UnownedDependencies" : "Dependencies"
            let dependenciesProtocolName = concreteDeclaration.name.trimmed.text + dependenciesSuffix
            let accessLevel = concreteDeclaration.modifiers.accessLevel.rawValue
            let dependenciesTypeAliasDeclaration: DeclSyntax =
            """
            \(raw: accessLevel) typealias Dependencies = \(raw: dependenciesProtocolName)
            """
            typeAliasDeclarations.append(dependenciesTypeAliasDeclaration)
        }

        return typeAliasDeclarations
    }

    private static func parentPropertyDeclarations(
        node: AttributeSyntax,
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> [DeclSyntax] {

        // Create the property declarations:
        var propertyDeclarations = [DeclSyntax]()

        // Create the dependencies stored property declaration:
        let dependenciesReferenceType = node.dependenciesReferenceTypeArgument ?? .strong
        let bindingModifier = dependenciesReferenceType == .unowned ? "unowned " : ""
        let dependenciesPropertyDeclaration: DeclSyntax =
        """
        private \(raw: bindingModifier)let _dependencies: any Dependencies
        """
        propertyDeclarations.append(dependenciesPropertyDeclaration)

        // Create the arguments stored property declaration:
        let argumentsPropertyDeclaration: DeclSyntax =
        """
        private let _arguments: Arguments
        """
        propertyDeclarations.append(argumentsPropertyDeclaration)

        return propertyDeclarations
    }

    private static func parentInitializerDeclarations(
        node: AttributeSyntax,
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> [DeclSyntax] {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw InjectableMacroProtocolError.declarationNotConcrete
        }

        // Create the initializer lines:
        var initializerLines = [
            "self._arguments = arguments",
            "self._dependencies = dependencies",
        ]

        // Call the designated initializer and implement the required initializers, if necessary:
        var requiredInitializers = [DeclSyntax]()
        if let superTypeArgument = node.superTypeArgument {
            switch superTypeArgument.asSource {
            case "UIViewController":
                initializerLines.append("super.init(nibName: nil, bundle: nil)")
                requiredInitializers = [
                    """
                    required init?(coder: NSCoder) {
                        fatalError("init(coder:) has not been implemented")
                    }
                    """
                ]
            case "UIView":
                initializerLines.append("super.init(frame: .zero)")
                requiredInitializers = [
                    """
                    required init?(coder: NSCoder) {
                        fatalError("init(coder:) has not been implemented")
                    }
                    """
                ]
            default:
                // TODO: Diagnostic
                fatalError()
            }
        }

        // Create the initializer:
        let accessLevel = concreteDeclaration.modifiers.accessLevel.rawValue
        let initializerDeclaration: DeclSyntax =
        """
        \(raw: accessLevel) init(arguments: Arguments, dependencies: any Dependencies) {
        \(raw: initializerLines.joined(separator: "\n"))
        }
        """

        return [initializerDeclaration] + requiredInitializers
    }

    // MARK: PeerMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        // Walk the declaration with the visitor:
        let visitor = DeclarationVisitor()
        visitor.walk(declaration)

        // Create the protocol declarations:
        let declarations: [DeclSyntax?] = [
            try self.dependenciesProtocolDeclaration(
                node: node,
                visitor: visitor,
                declaration: declaration
            )
        ]

        return declarations.compactMap { $0 }
    }

    private static func dependenciesProtocolDeclaration(
        node: AttributeSyntax,
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> DeclSyntax? {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw InjectableMacroProtocolError.declarationNotConcrete
        }

        // If the visitor has a handwritten dependencies type alias, return early:
        if visitor.dependenciesTypeAliasDeclaration != nil {
            return nil
        }

        // Create properties for the protocol:
        var protocolProperties = [String]()
        for (property, _) in visitor.injectProperties {
            guard let typeDescription = property.typeDescription else {
                // TODO: Diagnostic
                fatalError("Missing type annotation")
            }

            let protocolProperty = "var \(property.label): \(typeDescription.asSource) { get }"
            protocolProperties.append(protocolProperty)
        }
        let protocolBody = protocolProperties.joined(separator: "\n")

        // Create the child dependencies protocol declaration:
        let accessLevel = concreteDeclaration.modifiers.accessLevel.rawValue
        let dependenciesSuffix = (node.dependenciesReferenceTypeArgument ?? .strong) == .unowned ?
            "UnownedDependencies" : "Dependencies"
        let dependenciesProtocolName = concreteDeclaration.name.trimmed.text + dependenciesSuffix
        let dependenciesProtocolDeclaration: DeclSyntax =
        """
        \(raw: accessLevel) protocol \(raw: dependenciesProtocolName): AnyObject {\(raw: protocolBody)}
        """

        return dependenciesProtocolDeclaration
    }
}
