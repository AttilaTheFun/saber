import SwiftSyntax

extension AttributeListSyntax.Element {

    // MARK: Peer Macros

    public var injectableMacro: AttributeSyntax? {
        self.attributeIfNameEquals("Injectable")
    }

    public var scopeMacro: AttributeSyntax? {
        self.attributeIfNameEquals("Scope")
    }

    // MARK: Accessor Macros

    public var argumentMacro: AttributeSyntax? {
        self.attributeIfNameEquals("Argument")
    }

    public var injectMacro: AttributeSyntax? {
        self.attributeIfNameEquals("Inject")
    }

    public var factoryMacro: AttributeSyntax? {
        self.attributeIfNameEquals("Factory")
    }

    public var provideMacro: AttributeSyntax? {
        self.attributeIfNameEquals("Provide")
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
