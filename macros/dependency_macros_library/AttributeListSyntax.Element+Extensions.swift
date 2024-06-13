import SwiftSyntax

extension AttributeListSyntax.Element {
    public var argumentsMacro: AttributeSyntax? {
        self.attributeIfNameEquals("Arguments")
    }

    public var injectMacro: AttributeSyntax? {
        self.attributeIfNameEquals("Inject")
    }

    public var initializeMacro: AttributeSyntax? {
        self.attributeIfNameEquals("Initialize")
    }

    private func attributeIfNameEquals(_ expectedName: String) -> AttributeSyntax? {
        if
            case let .attribute(attribute) = self,
            let identifier = IdentifierTypeSyntax(attribute.attributeName),
            identifier.name.text == expectedName
        {
            return attribute
        }

        return nil
    }
}
