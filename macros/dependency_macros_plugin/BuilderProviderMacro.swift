import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum BuilderProviderMacroError: Error {
    case missingArgumentsSuffix
    case invalidDeclSyntax(any DeclSyntaxProtocol)
}

public struct BuilderProviderMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        // Extract the name and modifiers of the type:
        let nominalType = try Parsers.parseConcreteNominalTypeSyntax(declaration: declaration)

        // Create the provider protocol declaration:
        let argumentsTypeName = nominalType.name.text
        let declSyntax: [DeclSyntax] = [
            """
            public protocol \(raw: argumentsTypeName)BuilderProvider {
            var \(raw: argumentsTypeName.lowercasedFirstCharacter())Builder: any Builder<\(raw: argumentsTypeName), UIViewController> { get }
            }
            """
        ]

        return declSyntax
    }
}
