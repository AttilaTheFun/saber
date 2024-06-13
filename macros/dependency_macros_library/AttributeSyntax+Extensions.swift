import SwiftSyntax

extension AttributeSyntax {
    public var concreteTypeArgument: TypeDescription? {
        return self.argumentIfNameEquals(nil)
    }

    public var argumentsTypeArgument: TypeDescription? {
        return self.argumentIfNameEquals("argumentsType")
    }

    private func argumentIfNameEquals(_ expectedName: String?) -> TypeDescription? {
        guard
            let arguments = self.arguments,
            let labeledExpressionList = arguments.as(LabeledExprListSyntax.self),
            let labeledExpression = labeledExpressionList.first(where: { $0.label?.text == expectedName }) else
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
