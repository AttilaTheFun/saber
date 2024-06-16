import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum ArgumentsMacroProtocolError: Error {
    case notDecoratingBinding
    case decoratingStatic
}

public protocol ArgumentsMacroProtocol: AccessorMacro {}

extension ArgumentsMacroProtocol {

    // MARK: AccessorMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard
            let variableDeclaration = declaration.as(VariableDeclSyntax.self),
            let binding = variableDeclaration.bindings.first,
            binding.accessorBlock == nil else
        {
            return []
        }

        // Create the accessor declaration:
        let getAccessorDeclaration: AccessorDeclSyntax =
        """
        get {
            return self._arguments
        }
        """

        return [getAccessorDeclaration]
    }
}
