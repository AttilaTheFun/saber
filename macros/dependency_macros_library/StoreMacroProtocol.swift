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
            let typeAnnotation = binding.typeAnnotation,
            let identifierPattern = IdentifierPatternSyntax(binding.pattern),
            binding.accessorBlock == nil else
        {
            return []
        }

        // Parse the type description:
        let typeDescription = typeAnnotation.type.typeDescription
        if case .unknown(let description) = typeDescription {
            // TODO: Diagnostic.
            fatalError(description)
        }



        // Parse the type description:
        let property = Property(label: identifierPattern.identifier.text, typeDescription: typeDescription)
        if case .unknown(let description) = typeDescription {
            // TODO: Diagnostic.
            fatalError(description)
        }

        // Create the accessor declaration:
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

            // If the value has already been initialized, we can return it without a lock:
            var accessorLines = [
                "if let \(property.label) = self._\(property.label) {",
                "return \(property.label)",
                "}",
            ]

            // If thread safe, wrap initialization in lock:
            if storeMacro.threadSafetyStrategyArgument == .safe {
                // Repeat the same check because value could be initialized while obtaining the lock.
                // This makes initialization slightly slower in exchange for allowing all subsequent access
                // to avoid the lock penalty.
                accessorLines += [
                    "self._\(property.label)Lock.lock()",
                    "defer { self._\(property.label)Lock.unlock() }"
                ] + accessorLines
            }

            // Initialize and return the concrete type:
            accessorLines += [
                "let \(property.label) = \(concreteType.asSource)(dependencies: self)",
                "self._\(property.label) = \(property.label)",
                "return \(property.label)",
            ]

            // Create the accessor declaration:
            let accessorBody = accessorLines.joined(separator: "\n")
            getAccessorDeclaration =
            """
            get {
            \(raw: accessorBody)
            }
            """
        }

        return [getAccessorDeclaration]
    }
}
