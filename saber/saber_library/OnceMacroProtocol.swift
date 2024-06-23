import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public protocol OnceMacroProtocol: PeerMacro {}

extension OnceMacroProtocol {

    // MARK: PeerMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard
            let variableDeclaration = declaration.as(VariableDeclSyntax.self),
            variableDeclaration.bindings.count == 1,
            let binding = variableDeclaration.bindings.first,
            let identifierPattern = IdentifierPatternSyntax(binding.pattern),
            let typeAnnotation = binding.typeAnnotation else
        {
            return []
        }

        // Create the once property declaration:
        let typeDescription = typeAnnotation.type.typeDescription
        return [
            "private let \(identifierPattern.identifier.trimmed)Once = Once<\(raw: typeDescription.asSource)>()"
        ]
    }
}
