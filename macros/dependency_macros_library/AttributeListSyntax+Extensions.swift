import SwiftSyntax

extension AttributeListSyntax {
    public var argumentsMacro: AttributeSyntax? {
        guard let attribute = first(where: { element in
            element.argumentsMacro != nil
        }) else {
            return nil
        }
        return AttributeSyntax(attribute)
    }
}
