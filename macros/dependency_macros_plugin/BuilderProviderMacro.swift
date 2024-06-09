import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum BuilderProviderMacroError: Error {
    case missingArgumentsSuffix
    case invalidDeclSyntax(any DeclSyntaxProtocol)
}

public struct BuilderProviderMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        // Parse the type argument:
        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self) else {
            throw MacroError.invalidArgumentsType
        }
        guard let argument = arguments.first, arguments.count == 1 else {
            throw MacroError.invalidNumberOfArguments
        }
        guard argument.label == nil else {
            throw MacroError.invalidArgumentLabel(argument.label)
        }
        guard let buildingTypeName = Parsers.parseTypeArgument(expression: argument.expression) else {
            throw MacroError.invalidArgumentExpression(argument.expression)
        }

        // Extract the name of the type:
        let name: TokenSyntax
        let modifiers: DeclModifierListSyntax
        if let declaration = declaration.as(ProtocolDeclSyntax.self) {
            name = declaration.name
            modifiers = declaration.modifiers
        } else if let declaration = declaration.as(ClassDeclSyntax.self) {
            name = declaration.name
            modifiers = declaration.modifiers
        } else if let declaration = declaration.as(ActorDeclSyntax.self) {
            name = declaration.name
            modifiers = declaration.modifiers
        } else if let declaration = declaration.as(StructDeclSyntax.self) {
            name = declaration.name
            modifiers = declaration.modifiers
        } else if let declaration = declaration.as(EnumDeclSyntax.self) {
            name = declaration.name
            modifiers = declaration.modifiers
        } else {
            throw BuilderProviderMacroError.invalidDeclSyntax(declaration)
        }

        // Create the provider protocol declaration:
        let argumentsTypeName = name.text
        let declSyntax: [DeclSyntax] = [
            """
            \(modifiers.trimmed) protocol \(raw: argumentsTypeName)BuilderProvider {
            var \(raw: argumentsTypeName.lowercasedFirstCharacter())Builder: any Builder<\(raw: argumentsTypeName), \(raw: buildingTypeName)> { get }
            }
            """
        ]

        return declSyntax
    }
}
