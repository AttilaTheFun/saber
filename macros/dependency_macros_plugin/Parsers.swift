import SwiftSyntax

enum Parsers {
    /// Usage:
    /// ```
    /// try node.arguments?.as(LabeledExprListSyntax.self)?.forEach { labeledExpr in
    ///     ...
    ///     let typeName = MacroUtils.parseTypeArgument(expression: labeledExpr.expression)
    /// }
    /// ```
    static func parseTypeArgument(expression: ExprSyntax) -> String? {
        return expression.as(MemberAccessExprSyntax.self)?
            .base?
            .as(DeclReferenceExprSyntax.self)?
            .baseName
            .text
    }
}
