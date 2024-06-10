import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import DependencyMacrosLibrary

public enum ScopeViewControllerBuilderMacroError: Error {
    case missingArgumentsSuffix
    case invalidDeclSyntax(any DeclSyntaxProtocol)
}

public struct ScopeViewControllerBuilderMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        // Parse the arguments type:
        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self) else {
            throw MacroError.invalidArgumentsType
        }
        guard let argument = arguments.first, arguments.count == 1 else {
            throw MacroError.invalidNumberOfArguments
        }
        guard argument.label != "arguments" else {
            throw MacroError.invalidArgumentLabel(argument.label)
        }
        let argumentsType = try Parsers.parseMemberAccessBaseTypeName(expression: argument.expression)
        // TODO: See if I can just grab the Arguments type from the @Arguments macro.

        // Extract the name and modifiers of the type:
        let nominalType = try Parsers.parseNominalTypeSyntax(declaration: declaration)

        // Create the provider protocol declaration:
        let argumentsTypeName = argumentsType.text
        let nominalTypeName = nominalType.name.text
        let declSyntax: [DeclSyntax] = [
            """
            public final class \(raw: nominalTypeName)Builder: DependencyContainer<\(raw: nominalTypeName)Dependencies>, Builder {
            public func build(arguments: \(raw: argumentsTypeName)) -> UIViewController {
            let scope = \(raw: nominalTypeName)(dependencies: self.dependencies, arguments: arguments)
            return scope.\(raw: argumentsTypeName.lowercasedFirstCharacter())ViewControllerBuilder.build(arguments: arguments)
            }
            }
            """
        ]

        return declSyntax
    }
}
