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

public protocol ScopeMacroProtocol: MemberMacro, PeerMacro {}

extension ScopeMacroProtocol {

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
        let memberDeclarations = try self.parentPropertyDeclarations(
            node: node,
            visitor: visitor,
            declaration: declaration
        )

        return memberDeclarations
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

        return propertyDeclarations
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
        let factoryAttributeTuples = visitor.factoryProperties.map { ($0.1, false) }
        let storeAttributeTuples = visitor.storeProperties.map { ($0.1, true) }
        for (attributeSyntax, isStored) in factoryAttributeTuples + storeAttributeTuples {
            guard let concreteTypeDescription = attributeSyntax.concreteTypeArgument else {
                throw ScopeMacroProtocolError.invalidMacroArguments
            }

            // Use the dependencies type if provided, or derive the name from the concrete type if not:
            let fulfilledDependenciesProtocolName: String
            if let dependenciesTypeDescription = attributeSyntax.dependenciesTypeArgument {
                fulfilledDependenciesProtocolName = dependenciesTypeDescription.asSource
            } else {
                let suffix = isStored ? "UnownedDependencies" : "Dependencies"
                fulfilledDependenciesProtocolName = concreteTypeDescription.asSource + suffix
            }

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
