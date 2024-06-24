import SwiftSyntax

extension AttributeListSyntax.Element {

    // MARK: Common Macros

    public var injectableMacro: AttributeSyntax? {
        self.attributeIfNameEquals("Injectable")
    }

    public var injectMacro: AttributeSyntax? {
        self.attributeIfNameEquals("Inject")
    }

    // MARK: Scope Macros

    public var scopeMacro: AttributeSyntax? {
        self.attributeIfNameEquals("Scope")
    }

    public var argumentMacro: AttributeSyntax? {
        self.attributeIfNameEquals("Argument")
    }

    public var factoryMacro: AttributeSyntax? {
        self.attributeIfNameEquals("Factory")
    }

    public var fulfillMacro: AttributeSyntax? {
        self.attributeIfNameEquals("Fulfill")
    }

    public var storeMacro: AttributeSyntax? {
        self.attributeIfNameEquals("Store")
    }

    // MARK: Private

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
