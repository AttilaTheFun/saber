import SwiftSyntax

enum InjectableMacroType {
    case arguments(AttributeSyntax)
    case inject(AttributeSyntax)
    case initialize(AttributeSyntax)
}

extension AttributeListSyntax {
    public var argumentsMacro: AttributeSyntax? {
        for element in self {
            if let argumentsMacro = element.argumentsMacro {
                return argumentsMacro
            }
        }

        return nil
    }

    public var injectMacro: AttributeSyntax? {
        for element in self {
            if let injectMacro = element.injectMacro {
                return injectMacro
            }
        }

        return nil
    }

    public var initializeMacro: AttributeSyntax? {
        for element in self {
            if let initializeMacro = element.initializeMacro {
                return initializeMacro
            }
        }

        return nil
    }

    var injectableMacroType: InjectableMacroType? {
        if let argumentsMacro = self.argumentsMacro {
            return .arguments(argumentsMacro)
        }

        if let injectMacro = self.injectMacro {
            return .inject(injectMacro)
        }

        if let initializeMacro = self.initializeMacro {
            return .initialize(initializeMacro)
        }

        return nil
    }
}
