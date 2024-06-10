import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import DependencyMacrosLibrary

public enum ArgumentsMacroError: Error {
    case notDecoratingBinding
    case decoratingStatic
}

public struct ArgumentsMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let variableDecl = VariableDeclSyntax(declaration) else {
            throw ArgumentsMacroError.notDecoratingBinding
        }

        guard variableDecl.modifiers.staticModifier == nil else {
            throw ArgumentsMacroError.decoratingStatic
        }

        // Extract the name and modifiers of the type:
        let nominalType = try Parsers.parseConcreteNominalTypeSyntax(declaration: declaration)

        // Create the provider protocol declaration:
        let argumentsTypeName = nominalType.name.text
        let declSyntax: [DeclSyntax] = [
            """
            public protocol \(raw: argumentsTypeName)Arguments {
            var \(raw: argumentsTypeName.lowercasedFirstCharacter())Builder: any Builder<\(raw: argumentsTypeName), UIViewController> { get }
            }
            """
        ]

        return declSyntax
    }
}
