import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import DependencyMacrosLibrary

public enum FactoryMacroError: Error {
    case notDecoratingBinding
    case decoratingStatic
}

public struct FactoryMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let variableDecl = VariableDeclSyntax(declaration) else {
            throw FactoryMacroError.notDecoratingBinding
        }

        guard variableDecl.modifiers.staticModifier == nil else {
            throw FactoryMacroError.decoratingStatic
        }

        // This macro does not expand.
        return []
    }
}

public enum FactoryBuilderMacroError: Error {
    case notDecoratingBinding
    case decoratingStatic
}

public struct FactoryBuilderMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let variableDecl = VariableDeclSyntax(declaration) else {
            throw FactoryBuilderMacroError.notDecoratingBinding
        }

        guard variableDecl.modifiers.staticModifier == nil else {
            throw FactoryBuilderMacroError.decoratingStatic
        }

        // This macro does not expand.
        return []
    }
}
