import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import DependencyMacrosLibrary

public enum InstantiateMacroError: Error {
    case notDecoratingBinding
    case decoratingStatic
}

public struct InstantiateMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let variableDecl = VariableDeclSyntax(declaration) else {
            throw InstantiateMacroError.notDecoratingBinding
        }

        guard !variableDecl.modifiers.isStatic else {
            throw InstantiateMacroError.decoratingStatic
        }

        // This macro does not expand.
        return []
    }
}
