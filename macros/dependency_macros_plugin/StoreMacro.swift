import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import DependencyMacrosLibrary

public enum StoreMacroError: Error {
    case notDecoratingBinding
    case decoratingStatic
}

public struct StoreMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let variableDecl = VariableDeclSyntax(declaration) else {
            throw StoreMacroError.notDecoratingBinding
        }

        guard variableDecl.modifiers.staticModifier == nil else {
            throw StoreMacroError.decoratingStatic
        }

        // This macro does not expand.
        return []
    }
}
