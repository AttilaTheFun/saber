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

        // Extract the name of the type:
        let name: TokenSyntax
        let modifiers: DeclModifierListSyntax
        if let declaration = declaration.as(ProtocolDeclSyntax.self) {
            name = declaration.name
            modifiers = declaration.modifiers
        } else if let declaration = declaration.as(ClassDeclSyntax.self) {
            name = declaration.name
            modifiers = declaration.modifiers
        } else if let declaration = declaration.as(ActorDeclSyntax.self) {
            name = declaration.name
            modifiers = declaration.modifiers
        } else if let declaration = declaration.as(StructDeclSyntax.self) {
            name = declaration.name
            modifiers = declaration.modifiers
        } else if let declaration = declaration.as(EnumDeclSyntax.self) {
            name = declaration.name
            modifiers = declaration.modifiers
        } else {
            throw ProviderMacroError.invalidDeclSyntax(declaration)
        }

        // Create the provider protocol declaration:
        let typeName = name.text
        let declSyntax: [DeclSyntax] = [
            """
            \(modifiers.trimmed) protocol \(raw: typeName)Provider {
                var \(raw: typeName.lowercasedFirstCharacter()): \(raw: typeName) { get }
            }
            """
        ]

        return declSyntax
    }
}

extension String {
    func lowercasedFirstCharacter() -> String {
        guard let first else { return self }
        return first.lowercased() + self.dropFirst()
    }
}
