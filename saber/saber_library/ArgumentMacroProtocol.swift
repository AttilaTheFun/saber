import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum ArgumentMacroProtocolError: Error {
    case unknownType(String)
}

public protocol ArgumentMacroProtocol: AccessorMacro {}

extension ArgumentMacroProtocol {

    // MARK: AccessorMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard
            let variableDeclaration = declaration.as(VariableDeclSyntax.self),
            variableDeclaration.bindings.count == 1,
            let binding = variableDeclaration.bindings.first,
            let identifierPattern = IdentifierPatternSyntax(binding.pattern),
            binding.accessorBlock == nil else
        {
            return []
        }

        return [
            """
            get {
                return self.arguments.\(identifierPattern.identifier)
            }
            """
        ]
    }
}
