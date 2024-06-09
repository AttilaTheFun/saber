import SwiftSyntax

enum MacroError: Error {
    case invalidArgumentsType
    case invalidNumberOfArguments
    case invalidArgumentLabel(TokenSyntax?)
    case invalidArgumentExpression(ExprSyntax)
}
