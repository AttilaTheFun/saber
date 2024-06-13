
public typealias Initializer<Arguments, Building> = (Arguments) -> Building

public protocol Factory<Arguments, Building> {
    associatedtype Arguments
    associatedtype Building

    func build(arguments: Arguments) -> Building
}

extension Factory where Arguments == Void {
    public func build() -> Building {
        return self.build(arguments: ())
    }
}

public final class DefaultFactory<Arguments, Building>: Factory {
    private let function: (Arguments) -> Building

    public init(_ function: @escaping (Arguments) -> Building) {
        self.function = function
    }

    public func build(arguments: Arguments) -> Building {
        return self.function(arguments)
    }
}

public typealias FactoryBuilder<Dependencies, Arguments, Building> = (Dependencies) -> any Factory<Arguments, Building>

//public final class FactoryBuilder<Dependencies, Arguments, Building> {
//    private let curriedInitializer: (Dependencies) -> Factory<Arguments, Building>
//
//    public init(initializer: @escaping (Arguments, Dependencies) -> Building) {
//        self.curriedInitializer = { dependencies in
//            return { arguments in
//                initializer(arguments, dependencies)
//            }
//        }
//    }
//
//    public func build(dependencies: Dependencies) -> Factory<Arguments, Building> {
//        return self.curriedInitializer(dependencies)
//    }
//}
