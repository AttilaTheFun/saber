import SwiftSyntax

extension AttributeSyntax {
    public var typeDescription: TypeDescription? {
        guard
            let arguments = self.arguments,
            let labeledExpressionList = arguments.as(LabeledExprListSyntax.self),
            let labeledExpression = labeledExpressionList.first else
        {
            return nil
        }

        // Fail if the type was unknown:
        let typeDescription = labeledExpression.expression.typeDescription
        if case .unknown(let description) = typeDescription {
            fatalError(description)
        }

        return typeDescription
    }
}
