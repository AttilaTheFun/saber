import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum ProvideMacroProtocolError: Error {
    case unknownType(String)
}

public protocol ProvideMacroProtocol: AccessorMacro {}

extension ProvideMacroProtocol {

    // MARK: AccessorMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        // This macro does not expand.
        return []
    }
}
