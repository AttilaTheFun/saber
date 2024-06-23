import SwiftSyntax

enum InjectableMacroType {
    case argument(AttributeSyntax)
    case inject(AttributeSyntax)
    case fulfill(AttributeSyntax)
}

extension AttributeListSyntax {

    // MARK: Common Macros

    public var injectableMacro: AttributeSyntax? {
        for element in self {
            if let injectMacro = element.injectableMacro {
                return injectMacro
            }
        }

        return nil
    }

    // MARK: Scope Macros

    public var scopeMacro: AttributeSyntax? {
        for element in self {
            if let injectMacro = element.scopeMacro {
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

    // MARK: Accessor Macros

    var injectableMacroTypes: [InjectableMacroType] {
        var injectableMacroTypes: [InjectableMacroType] = []
        for element in self {
            if let argumentMacro = element.argumentMacro {
                injectableMacroTypes.append(.argument(argumentMacro))
            }

            if let injectMacro = element.injectMacro {
                injectableMacroTypes.append(.inject(injectMacro))
            }

            if let fulfillMacro = element.fulfillMacro {
                injectableMacroTypes.append(.fulfill(fulfillMacro))
            }
        }

        return injectableMacroTypes
    }
}
