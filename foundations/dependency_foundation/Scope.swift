
public protocol Scope {
    func new<T>(_ function: @escaping () -> T) -> T
    func shared<T>(_ function: @escaping () -> T) -> T
}

open class BaseScope<Dependencies>: DependencyContainer<Dependencies> {
    private var factories = [ObjectIdentifier : Any]()
    private var sharedInstances = [ObjectIdentifier : Any]()

    public func new<T>(_ function: @escaping () -> T) -> T {
        let identifier = ObjectIdentifier(T.self)
        if let factory = self.factories[identifier] as? () -> T {
            return factory()
        }

        self.factories[identifier] = function
        return function()
    }

    public func shared<T>(_ function: @escaping () -> T) -> T {
        let identifier = ObjectIdentifier(T.self)
        if let instance = self.sharedInstances[identifier] as? T {
            return instance
        }

        let instance = self.new(function)
        self.sharedInstances[identifier] = instance
        return instance
    }
}
