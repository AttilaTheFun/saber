import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public protocol StoreMacroProtocol: AccessorMacro {}

extension StoreMacroProtocol {

    // MARK: AccessorMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard
            let variableDeclaration = declaration.as(VariableDeclSyntax.self),
            let binding = variableDeclaration.bindings.first,
            let identifierPattern = IdentifierPatternSyntax(binding.pattern),
            binding.accessorBlock == nil else
        {
            return []
        }

        // Create the property declaration:
        let accessorDeclaration: AccessorDeclSyntax =
        """
        get {
            return self.\(identifierPattern.identifier.trimmed)Store.value
        }
        """

        return [accessorDeclaration]
    }
}
