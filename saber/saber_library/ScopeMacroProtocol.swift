import SaberTypes
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum ScopeMacroProtocolError: Error {
    case declarationNotConcrete
    case invalidMacroArguments
    case invalidProperty
    case invalidComputedPropertyName
    case invalidComputedPropertyType
}

public protocol ScopeMacroProtocol: ExtensionMacro, MemberMacro, PeerMacro {}

extension ScopeMacroProtocol {

    // MARK: ExtensionMacro

    public static func expansion(
      of node: AttributeSyntax,
      attachedTo declaration: some DeclGroupSyntax,
      providingExtensionsOf type: some TypeSyntaxProtocol,
      conformingTo protocols: [TypeSyntax],
      in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {

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
        let inheritedProtocolType = TypeSyntax(stringLiteral: "ArgumentsAndDependenciesInitializable")
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
        in context: some MacroExpansionContext) throws
        -> [DeclSyntax]
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

        // If there there is *not* a handwritten initializer we need to generate it:
        let shouldGenerateInitializer = visitor.initArgumentsAndDependenciesDeclaration == nil
        if shouldGenerateInitializer {
            let memberDeclaration = try self.parentInitializerDeclaration(
                node: node,
                visitor: visitor,
                declaration: declaration
            )
            memberDeclarations.append(memberDeclaration)
        }

        return memberDeclarations
    }

    private static func parentTypeAliasDeclarations(
        node: AttributeSyntax,
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> [DeclSyntax] {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw ScopeMacroProtocolError.declarationNotConcrete
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

        return typeAliasDeclarations
    }

    private static func parentPropertyDeclarations(
        node: AttributeSyntax,
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> [DeclSyntax] {

        // Add store properties for each of the @Store macros:
        var propertyDeclarations = [DeclSyntax]()
        for (property, attributeSyntax) in visitor.storeProperties {
            guard let concreteType = attributeSyntax.concreteTypeArgument else {
                throw ScopeMacroProtocolError.invalidMacroArguments
            }

            // Create the property declaration:
            let propertyDeclaration: DeclSyntax =
            """
            private lazy var \(raw: property.label)Store = Store { [unowned self] in
            \(raw: concreteType.asSource)(dependencies: self)
            }
            """
            propertyDeclarations.append(propertyDeclaration)
        }

        // Create the arguments stored property declaration:
        let argumentsPropertyDeclaration: DeclSyntax =
        """
        private let _arguments: Arguments
        """
        propertyDeclarations.append(argumentsPropertyDeclaration)

        return propertyDeclarations
    }

    private static func parentInitializerDeclaration(
        node: AttributeSyntax,
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> DeclSyntax {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw ScopeMacroProtocolError.declarationNotConcrete
        }

        // Create the initializer:
        let accessLevel = concreteDeclaration.modifiers.accessLevel.rawValue
        let initializerDeclaration: DeclSyntax =
        """
        \(raw: accessLevel) init(arguments: Arguments, dependencies: any Dependencies) {
            self._arguments = arguments
            self._dependencies = dependencies
        }
        """

        return initializerDeclaration
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

        // Create the protocol declaration:
        let fulfilledDependenciesProtocolDeclaration = try self.fulfilledDependenciesProtocolDeclaration(
            node: node,
            visitor: visitor,
            declaration: declaration
        )

        return [fulfilledDependenciesProtocolDeclaration]
    }

    private static func fulfilledDependenciesProtocolDeclaration(
        node: AttributeSyntax,
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> DeclSyntax {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw ScopeMacroProtocolError.declarationNotConcrete
        }

        // Extract the dependencies protocol names from the factory and store properties:
        var inheritedProtocolNames = ["AnyObject"]
        for (_, attributeSyntax) in visitor.fulfillProperties {
            guard let concreteTypeDescription = attributeSyntax.concreteTypeArgument else {
                throw ScopeMacroProtocolError.invalidMacroArguments
            }

            let fulfilledDependenciesProtocolName = concreteTypeDescription.asSource
            inheritedProtocolNames.append(fulfilledDependenciesProtocolName)
        }

        // Create the inheritance clause:
        let inheritedTypes = inheritedProtocolNames.enumerated().map { index, protocolName in
            let trailingComma: TokenSyntax? = index < (inheritedProtocolNames.endIndex - 1) ?
                TokenSyntax.commaToken() : nil
            return InheritedTypeSyntax(type: TypeSyntax(stringLiteral: protocolName), trailingComma: trailingComma)
        }
        let inheritedTypeList = InheritedTypeListSyntax(inheritedTypes)
        let inheritanceClause = InheritanceClauseSyntax(inheritedTypes: inheritedTypeList)

        // Create the fulfilled dependencies protocol declaration:
        let accessLevel = concreteDeclaration.modifiers.accessLevel.rawValue
        let fulfilledDependenciesProtocolName = "\(concreteDeclaration.name.trimmed)FulfilledDependencies"
        let fulfilledDependenciesProtocolDeclaration = ProtocolDeclSyntax(
            modifiers: DeclModifierListSyntax([
                DeclModifierSyntax(
                    name: TokenSyntax(stringLiteral: accessLevel)
                )
            ]),
            name: TokenSyntax(stringLiteral: fulfilledDependenciesProtocolName),
            inheritanceClause: inheritanceClause,
            memberBlock: MemberBlockSyntax(members: [])
        )

        return DeclSyntax(fulfilledDependenciesProtocolDeclaration)
    }
}
