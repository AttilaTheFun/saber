import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum StoreMacroProtocolError: Error {
    case notDecoratingBinding
    case decoratingStatic
}

public protocol StoreMacroProtocol: AccessorMacro, PeerMacro {}

extension StoreMacroProtocol {

    // MARK: AccessorMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard
            let property = declaration.as(VariableDeclSyntax.self),
            let storeMacro = property.attributes.storeMacro,
            let concreteType = storeMacro.concreteTypeArgument,
            let binding = property.bindings.first,
            binding.accessorBlock == nil else
        {
            return []
        }

        // Create the accessor declaration:
        let referenceStrategy = storeMacro.referenceStrategyArgument
        let getAccessorDeclaration: AccessorDeclSyntax =
        """
        get {
            self.\(raw: referenceStrategy.rawValue) { [unowned self] in
                \(raw: concreteType.asSource)(dependencies: self)
            }
        }
        """
        // TODO: See if it's possible to use an implicit get accessor with AccessorDeclSyntax.
        // That is, a computed property body without an explicit get / set is assumed to be the get accessor.

        return [getAccessorDeclaration]
    }

    // MARK: PeerMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let variableDecl = VariableDeclSyntax(declaration) else {
            throw StoreMacroProtocolError.notDecoratingBinding
        }

        guard !variableDecl.modifiers.isStatic else {
            throw StoreMacroProtocolError.decoratingStatic
        }

        // This macro does not expand.
        return []
    }
}
