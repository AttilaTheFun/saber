import SwiftSyntax

extension AttributeListSyntax.Element {
    public var argumentsMacro: AttributeSyntax? {
        self.attributeIfNameEquals(Constants.argumentsMacroName)
    }

    private func attributeIfNameEquals(_ expectedName: String) -> AttributeSyntax? {
        if
            case let .attribute(attribute) = self,
            let identifier = IdentifierTypeSyntax(attribute.attributeName),
            identifier.name.text == expectedName
        {
            attribute
        } else {
            nil
        }
    }
}
