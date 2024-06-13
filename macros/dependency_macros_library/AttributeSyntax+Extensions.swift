import SwiftSyntax

extension AttributeSyntax {
    public var concreteTypeDescription: TypeDescription? {
        guard
            let arguments = self.arguments,
            let labeledExpressionList = arguments.as(LabeledExprListSyntax.self),
            let labeledExpression = labeledExpressionList.first,
            let typeDescription = try? TypeDescription(expression: labeledExpression.expression) else
        {
            return nil
        }

        return typeDescription
    }
}
