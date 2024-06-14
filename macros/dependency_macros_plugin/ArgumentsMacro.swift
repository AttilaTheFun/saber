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

        guard !variableDecl.modifiers.isStatic else {
            throw ArgumentsMacroError.decoratingStatic
        }

        // This macro does not expand.
        return []
    }
}
