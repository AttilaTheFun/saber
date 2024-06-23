import SwiftSyntax

enum InjectableMacroType {
    case argument(AttributeSyntax)
    case inject(AttributeSyntax)
    case factory(AttributeSyntax)
    case provide(AttributeSyntax)
    case store(AttributeSyntax)
}

extension AttributeListSyntax {

    // MARK: Peer Macros

    public var injectableMacro: AttributeSyntax? {
        for element in self {
            if let injectMacro = element.injectableMacro {
                return injectMacro
            }
        }

        return nil
    }

    public var scopeMacro: AttributeSyntax? {
        for element in self {
            if let injectMacro = element.scopeMacro {
                return injectMacro
            }
        }

        return nil
    }

    // MARK: Accessor Macros

//    public var argumentMacro: AttributeSyntax? {
//        for element in self {
//            if let argumentMacro = element.argumentMacro {
//                return argumentMacro
//            }
//        }
//
//        return nil
//    }
//
//    public var injectMacro: AttributeSyntax? {
//        for element in self {
//            if let injectMacro = element.injectMacro {
//                return injectMacro
//            }
//        }
//
//        return nil
//    }
//
//    public var factoryMacro: AttributeSyntax? {
//        for element in self {
//            if let factoryMacro = element.factoryMacro {
//                return factoryMacro
//            }
//        }
//
//        return nil
//    }
//
//    public var provideMacro: AttributeSyntax? {
//        for element in self {
//            if let provideMacro = element.provideMacro {
//                return provideMacro
//            }
//        }
//
//        return nil
//    }
//
//    public var storeMacro: AttributeSyntax? {
//        for element in self {
//            if let storeMacro = element.storeMacro {
//                return storeMacro
//            }
//        }
//
//        return nil
//    }

    var injectableMacroTypes: [InjectableMacroType] {
        var injectableMacroTypes: [InjectableMacroType] = []
        for element in self {
            if let argumentMacro = element.argumentMacro {
                injectableMacroTypes.append(.argument(argumentMacro))
            }

            if let injectMacro = element.injectMacro {
                injectableMacroTypes.append(.inject(injectMacro))
            }

            if let factoryMacro = element.factoryMacro {
                injectableMacroTypes.append(.factory(factoryMacro))
            }

            if let provideMacro = element.provideMacro {
                injectableMacroTypes.append(.provide(provideMacro))
            }

            if let storeMacro = element.storeMacro {
                injectableMacroTypes.append(.store(storeMacro))
            }
        }

        return injectableMacroTypes
    }
}
