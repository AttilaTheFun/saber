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

            // Create the body of the accessor:
            var accessorLines = [
                "let \(property.label): \(property.typeDescription.asSource)",
                "if let _\(property.label) = self._\(property.label) {",
                "\(property.label) = _\(property.label)",
                "} else {",
                "\(property.label) = \(concreteType.asSource)(dependencies: self)",
                "}",
            ]

            // If thread safe, wrap in lock:
            if storeMacro.threadSafetyStrategyArgument == .safe {
                let lockLine = "self._\(property.label)Lock.lock()"
                let unlockLine = "defer { self._\(property.label)Lock.unlock() }"
                accessorLines = [lockLine, unlockLine] + accessorLines
            }

            // Add the return line:
            let returnLine = "return \(property.label)"
            accessorLines.append(returnLine)

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
