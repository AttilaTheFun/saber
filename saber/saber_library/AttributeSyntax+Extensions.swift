import SaberTypes
import SwiftSyntax

extension AttributeSyntax {
    public var concreteTypeArgument: TypeDescription? {
        return self.typeDescriptionIfNameEquals(nil)
    }

    public var existentialTypeArgument: TypeDescription? {
        return self.typeDescriptionIfNameEquals(nil)
    }

    public var superTypeArgument: TypeDescription? {
        return self.typeDescriptionIfNameEquals(nil)
    }

    private func typeDescriptionIfNameEquals(_ expectedName: String?) -> TypeDescription? {
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

    public var factoryKeyPathArgument: String? {
        return self.keyPathBaseNameIfNameEquals("factory")
    }

    private func keyPathBaseNameIfNameEquals(_ expectedName: String?) -> String? {
        guard
            let arguments = self.arguments,
            let labeledExpressionList = arguments.as(LabeledExprListSyntax.self),
            let labeledExpression = labeledExpressionList.first(where: { $0.label?.text == expectedName }),
            let keyPathExpression = KeyPathExprSyntax(labeledExpression.expression),
            let firstComponent = keyPathExpression.components.first,
            let keyPathComponent = KeyPathComponentSyntax(firstComponent),
            let keyPathPropertyComponent = KeyPathPropertyComponentSyntax(keyPathComponent.component) else
        {
            return nil
        }

        return keyPathPropertyComponent.declName.baseName.text
    }

    public var dependenciesReferenceTypeArgument: DependenciesReferenceType? {
        let rawValue = self.memberAccessBaseNameIfNameEquals("dependencies")
        return DependenciesReferenceType(rawValue: rawValue ?? "")
    }

    public var fulfilledDependenciesReferenceTypeArgument: FulfilledDependenciesReferenceType? {
        let rawValue = self.memberAccessBaseNameIfNameEquals("fulfilledDependencies")
        return FulfilledDependenciesReferenceType(rawValue: rawValue ?? "")
    }

    private func memberAccessBaseNameIfNameEquals(_ expectedName: String?) -> String? {
        guard
            let arguments = self.arguments,
            let labeledExpressionList = arguments.as(LabeledExprListSyntax.self),
            let labeledExpression = labeledExpressionList.first(where: { $0.label?.text == expectedName }),
            let memberAccessExpression = MemberAccessExprSyntax(labeledExpression.expression) else
        {
            return nil
        }

        return memberAccessExpression.declName.baseName.text
    }
}
