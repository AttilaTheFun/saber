import SwiftSyntax

extension DeclModifierListSyntax {
    public var staticModifier: Element? {
        first(where: { modifier in
            modifier.name.text == "static"
        })
    }
}
