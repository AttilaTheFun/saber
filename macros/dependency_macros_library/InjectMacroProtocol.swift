import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum InjectMacroProtocolError: Error {
    case unknownType(String)
}

public protocol InjectMacroProtocol: AccessorMacro {}

extension InjectMacroProtocol {

    // MARK: AccessorMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard
            let variableDeclaration = declaration.as(VariableDeclSyntax.self),
            !variableDeclaration.modifiers.isStatic,
            let injectMacro = variableDeclaration.attributes.injectMacro,
            let binding = variableDeclaration.bindings.first,
            let identifierPatternSyntax = IdentifierPatternSyntax(binding.pattern),
            binding.accessorBlock == nil else
        {
            return []
        }

        // Create the accessor declaration:
        let propertyIdentifier = identifierPatternSyntax.identifier
        let getAccessorDeclaration: AccessorDeclSyntax
        switch injectMacro.accessStrategyArgument ?? .computed {
        case .computed:
            getAccessorDeclaration =
            """
            get {
                return self._dependencies.\(propertyIdentifier)
            }
            """

        case .weak, .strong:
            getAccessorDeclaration =
            """
            get {
                if let \(propertyIdentifier) = self._\(propertyIdentifier) {
                    return \(propertyIdentifier)
                }

                let \(propertyIdentifier) = self._dependencies.\(propertyIdentifier)
                self._\(propertyIdentifier) = \(propertyIdentifier)
                return \(propertyIdentifier)
            }
            """
        }

        return [getAccessorDeclaration]
    }
}
