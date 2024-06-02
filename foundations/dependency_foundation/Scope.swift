import SwiftFoundation

open class Scope<Dependencies>: DependencyContainer<Dependencies> {
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

    public func strong<T>(_ function: @escaping () -> T) -> T {
        let identifier = ObjectIdentifier(T.self)
        if let wrapper = self.sharedInstances[identifier] as? StrongWrapper<T>, let value = wrapper.value {
            return value
        }

        let value = self.new(function)
        self.sharedInstances[identifier] = StrongWrapper(value: value)
        return value
    }

    public func weak<T: AnyObject>(_ function: @escaping () -> T) -> T {
        let identifier = ObjectIdentifier(T.self)
        if let wrapper = self.sharedInstances[identifier] as? WeakWrapper<T>, let value = wrapper.value {
            return value
        }

        let value = self.new(function)
        self.sharedInstances[identifier] = WeakWrapper(value: value)
        return value
    }
}
