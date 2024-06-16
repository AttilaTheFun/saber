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
            let concreteType = factoryMacro.concreteTypeArgument,
            let binding = variableDeclaration.bindings.first,
            binding.accessorBlock == nil else
        {
            return []
        }

        // Create the factory lines:
        let factoryLines: [String]
        if let factoryKeyPathArgument = factoryMacro.factoryKeyPathArgument {
            factoryLines = [
                "let concrete = \(concreteType.asSource)(arguments: arguments, dependencies: childDependencies)",
                "return concrete.\(factoryKeyPathArgument).build(arguments: arguments)"
            ]
        } else {
            factoryLines = [
                "\(concreteType.asSource)(arguments: arguments, dependencies: childDependencies)"
            ]
        }

        // Create the accessor declaration:
        let getAccessorDeclaration: AccessorDeclSyntax =
        """
        get {
            let childDependencies = self._childDependenciesStore.building
            return FactoryImplementation { [childDependencies] arguments in
                \(raw: factoryLines.joined(separator: "        \n"))
            }
        }
        """

        return [getAccessorDeclaration]
    }
}
