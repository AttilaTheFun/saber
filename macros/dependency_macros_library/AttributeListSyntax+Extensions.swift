import SwiftSyntax

enum InjectableMacroType {
    case arguments(AttributeSyntax)
    case inject(AttributeSyntax)
    case instantiate(AttributeSyntax)
}

extension AttributeListSyntax {
    public var argumentsMacro: AttributeSyntax? {
        for element in self {
            if let instantiateMacro = element.argumentsMacro {
                return instantiateMacro
            }
        }

        return nil
    }

    public var injectMacro: AttributeSyntax? {
        for element in self {
            if let instantiateMacro = element.injectMacro {
                return instantiateMacro
            }
        }

        return nil
    }

    public var instantiateMacro: AttributeSyntax? {
        for element in self {
            if let instantiateMacro = element.instantiateMacro {
                return instantiateMacro
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

        if let instantiateMacro = self.instantiateMacro {
            return .instantiate(instantiateMacro)
        }

        return nil
    }
}
