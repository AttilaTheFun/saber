import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import DependencyMacrosLibrary

public struct InjectableMacro: PeerMacro, MemberMacro {

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
            let protocolProperty = "var \(injectedProperty.label): \(injectedProperty.typeName) { get }"
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
        let declSyntax: [DeclSyntax] = [
            """
            \(raw: nominalTypeAccessLevel) protocol \(raw: typeName)Dependencies {
            \(raw: protocolBody)
            }
            """
        ]

        return declSyntax
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
        let nominalType = try Parsers.parseNominalTypeSyntax(declaration: declaration)
        let typeName = nominalType.name.text

        // Create the dependencies property:
        let dependenciesPropertyDeclaration: DeclSyntax =
        """
        private let dependencies: any \(raw: typeName)Dependencies
        """

        // Parse the properties:
        let visitor = InjectableVisitor()
        visitor.walk(declaration)

        // Create the initializer arguments:
        var initializerArguments = [String]()
        var initializerLines = [String]()
        if let argumentsProperty = visitor.argumentsProperty {
            initializerArguments.append("arguments: \(argumentsProperty.typeName)")
            initializerLines.append("self.\(argumentsProperty.label) = arguments")
        }
        initializerArguments.append("dependencies: some \(typeName)Dependencies")
        initializerLines.append("self.dependencies = dependencies")
        for injectedProperty in visitor.injectedProperties {
            initializerLines.append("self.\(injectedProperty.label) = dependencies.\(injectedProperty.label)")
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

        return [dependenciesPropertyDeclaration, initializerDeclaration]
    }
}

extension String {
    public func lowercasedFirstCharacter() -> String {
        guard let first else { return self }
        return first.lowercased() + self.dropFirst()
    }
}


public struct NominalTypeSyntax {
    public let modifiers: DeclModifierListSyntax
    public let name: TokenSyntax
    public let inheritanceClause: InheritanceClauseSyntax?
}

public enum ParserError: Error {
    case invalidExprSyntax(ExprSyntax)
    case invalidDeclSyntax(any SyntaxProtocol)
}
