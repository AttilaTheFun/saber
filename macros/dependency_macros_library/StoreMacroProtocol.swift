import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum StoreMacroProtocolError: Error {
    case notDecoratingBinding
    case decoratingStatic
}

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
            let storeMacro = variableDeclaration.attributes.storeMacro,
            let concreteType = storeMacro.concreteTypeArgument,
            let binding = variableDeclaration.bindings.first,
            let identifierPatternSyntax = IdentifierPatternSyntax(binding.pattern),
            binding.accessorBlock == nil else
        {
            return []
        }

        // TODO: Handle thread safety.
        let threadSafetyStrategy = storeMacro.threadSafetyStrategyArgument

        // Create the accessor declaration:
        let propertyIdentifier = identifierPatternSyntax.identifier
        let getAccessorDeclaration: AccessorDeclSyntax
        switch storeMacro.accessStrategyArgument ?? .strong {
        case .computed:
            getAccessorDeclaration =
            """
            get {
                return \(raw: concreteType.asSource)(dependencies: self)
            }
            """
        case .weak, .strong:
            getAccessorDeclaration =
            """
            get {
                if let \(propertyIdentifier) = self._\(propertyIdentifier) {
                    return \(propertyIdentifier)
                }

                let \(propertyIdentifier) = \(raw: concreteType.asSource)(dependencies: self)
                self._\(propertyIdentifier) = \(propertyIdentifier)
                return \(propertyIdentifier)
            }
            """
        }

        return [getAccessorDeclaration]
    }
}
