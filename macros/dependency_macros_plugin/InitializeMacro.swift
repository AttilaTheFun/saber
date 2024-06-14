import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import DependencyMacrosLibrary

public enum InitializeMacroError: Error {
    case notDecoratingBinding
    case decoratingStatic
}

public struct InitializeMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let variableDecl = VariableDeclSyntax(declaration) else {
            throw InitializeMacroError.notDecoratingBinding
        }

        guard !variableDecl.modifiers.isStatic else {
            throw InitializeMacroError.decoratingStatic
        }

        // This macro does not expand.
        return []
    }
}
