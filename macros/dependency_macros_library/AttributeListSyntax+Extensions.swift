import SwiftSyntax

enum InjectableMacroType {
    case arguments
    case inject
}

extension AttributeListSyntax {
    public var argumentsMacro: AttributeSyntax? {
        guard let attribute = self.first(where: { element in
            element.argumentsMacro != nil
        }) else {
            return nil
        }

        return AttributeSyntax(attribute)
    }

    public var injectMacro: AttributeSyntax? {
        guard let attribute = self.first(where: { element in
            element.injectMacro != nil
        }) else {
            return nil
        }

        return AttributeSyntax(attribute)
    }

    var injectableMacroType: InjectableMacroType? {
        if self.argumentsMacro != nil {
            return .arguments
        }

        if self.injectMacro != nil {
            return .inject
        }

        return nil
    }
}
