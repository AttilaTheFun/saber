import SwiftSyntax

enum InjectableMacroType {
    case arguments(AttributeSyntax)
    case inject(AttributeSyntax)
    case factory(AttributeSyntax)
    case store(AttributeSyntax)
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

    public var factoryMacro: AttributeSyntax? {
        for element in self {
            if let factoryMacro = element.factoryMacro {
                return factoryMacro
            }
        }

        return nil
    }

    public var storeMacro: AttributeSyntax? {
        for element in self {
            if let storeMacro = element.storeMacro {
                return storeMacro
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

        if let factoryMacro = self.factoryMacro {
            return .factory(factoryMacro)
        }

        if let storeMacro = self.storeMacro {
            return .store(storeMacro)
        }

        return nil
    }
}
