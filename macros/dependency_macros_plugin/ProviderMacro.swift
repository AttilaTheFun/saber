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
        let typeNameToken: TokenSyntax
        if let declaration = declaration.as(ProtocolDeclSyntax.self) {
            typeNameToken = declaration.name
        } else if let declaration = declaration.as(ClassDeclSyntax.self) {
            typeNameToken = declaration.name
        } else if let declaration = declaration.as(ActorDeclSyntax.self) {
            typeNameToken = declaration.name
        } else if let declaration = declaration.as(StructDeclSyntax.self) {
            typeNameToken = declaration.name
        } else if let declaration = declaration.as(EnumDeclSyntax.self) {
            typeNameToken = declaration.name
        } else {
            throw ProviderMacroError.invalidDeclSyntax(declaration)
        }

        // Create the provider protocol declaration:
        let typeName = typeNameToken.text
        let declSyntax: [DeclSyntax] = [
            """
            protocol \(raw: typeName)Provider {
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
