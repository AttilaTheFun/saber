import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum FactoryMacroProtocolError: Error {
    case notDecoratingBinding
    case decoratingStatic
}

public protocol FactoryMacroProtocol: AccessorMacro {}

extension FactoryMacroProtocol {

    // MARK: AccessorMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard
            let variableDeclaration = declaration.as(VariableDeclSyntax.self),
            let factoryMacro = variableDeclaration.attributes.factoryMacro,
            let concreteType = factoryMacro.concreteTypeArgument else
        {
            return []
        }

        // Create the factory lines:
        let concreteInitializer = "\(concreteType.asSource)(arguments: arguments, dependencies: self)"
        let factoryLines: [String]
        if let factoryKeyPathArgument = factoryMacro.factoryKeyPathArgument {
            factoryLines = [
                "let concrete = \(concreteInitializer)",
                "return concrete.\(factoryKeyPathArgument).build(arguments: arguments)"
            ]
        } else {
            factoryLines = [
                concreteInitializer
            ]
        }

        // Create the accessor declaration:
        let getAccessorDeclaration: AccessorDeclSyntax =
        """
        get {
            Factory { arguments in
                \(raw: factoryLines.joined(separator: "\n"))
            }
        }
        """

        return [getAccessorDeclaration]
    }
}
