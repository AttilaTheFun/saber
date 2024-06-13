import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import DependencyMacrosLibrary

public enum InjectMacroError: Error {
    case notDecoratingBinding
    case decoratingStatic
}

public struct InjectMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let variableDecl = VariableDeclSyntax(declaration) else {
            throw InjectMacroError.notDecoratingBinding
        }

        guard variableDecl.modifiers.staticModifier == nil else {
            throw InjectMacroError.decoratingStatic
        }

        // This macro does not expand.
        return []
    }
}
