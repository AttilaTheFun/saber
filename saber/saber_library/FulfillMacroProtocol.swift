import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public protocol FulfillMacroProtocol: PeerMacro {}

extension FulfillMacroProtocol {

    // MARK: AccessorMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext) throws -> [DeclSyntax]
    {
       // This macro does not expand.
       return []
    }

//    public static func expansion(
//        of node: AttributeSyntax,
//        providingAccessorsOf declaration: some DeclSyntaxProtocol,
//        in context: some MacroExpansionContext
//    ) throws -> [AccessorDeclSyntax] {
//        // This macro does not expand.
//        return []
//    }
}
