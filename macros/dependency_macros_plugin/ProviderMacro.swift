import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum ProviderMacroError: Error {
    case invalidDeclSyntax(any DeclSyntaxProtocol)
}

public struct ProviderMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        // Extract the name and modifiers of the type:
        let nominalType = try Parsers.parseNominalTypeSyntax(declaration: declaration)

        // Create the provider protocol declaration:
        let typeName = nominalType.name.text
        let declSyntax: [DeclSyntax] = [
            """
            \(nominalType.modifiers.trimmed) protocol \(raw: typeName)Provider {
            var \(raw: typeName.lowercasedFirstCharacter()): \(raw: typeName) { get }
            }
            """
        ]

        return declSyntax
    }
}
