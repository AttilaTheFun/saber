import SwiftFoundation

@MainActor
open class BaseScope {
    public init() {}
    
    private var factories = [ObjectIdentifier : Any]()
    private var instances = [ObjectIdentifier : Any]()
    private var plugins = [ObjectIdentifier : [Any]]()

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
        if let wrapper = self.instances[identifier] as? StrongWrapper<T>, let value = wrapper.value {
            return value
        }

        let value = self.new(function)
        self.instances[identifier] = StrongWrapper(value: value)
        return value
    }

    public func weak<T: AnyObject>(_ function: @escaping () -> T) -> T {
        let identifier = ObjectIdentifier(T.self)
        if let wrapper = self.instances[identifier] as? WeakWrapper<T>, let value = wrapper.value {
            return value
        }

        let value = self.new(function)
        self.instances[identifier] = WeakWrapper(value: value)
        return value
    }

    public func registerPlugins<Plugin>(plugins: [Plugin]) {
        let typeIdentifier = ObjectIdentifier(Plugin.self)
        self.plugins[typeIdentifier] = plugins
    }

    public func getPlugins<PluginType>(type: PluginType.Type) -> [PluginType] {
        let typeIdentifier = ObjectIdentifier(PluginType.self)
        return self.plugins[typeIdentifier, default: []] as? [PluginType] ?? []
    }
}


@MainActor
open class Scope<Dependencies>: DependencyContainer<Dependencies> {
    private var factories = [ObjectIdentifier : Any]()
    private var instances = [ObjectIdentifier : Any]()
    private var plugins = [ObjectIdentifier : [Any]]()

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
        if let wrapper = self.instances[identifier] as? StrongWrapper<T>, let value = wrapper.value {
            return value
        }

        let value = self.new(function)
        self.instances[identifier] = StrongWrapper(value: value)
        return value
    }

    public func weak<T: AnyObject>(_ function: @escaping () -> T) -> T {
        let identifier = ObjectIdentifier(T.self)
        if let wrapper = self.instances[identifier] as? WeakWrapper<T>, let value = wrapper.value {
            return value
        }

        let value = self.new(function)
        self.instances[identifier] = WeakWrapper(value: value)
        return value
    }

    public func registerPlugins<Plugin>(plugins: [Plugin]) {
        let typeIdentifier = ObjectIdentifier(Plugin.self)
        self.plugins[typeIdentifier] = plugins
    }

    public func getPlugins<PluginType>(type: PluginType.Type) -> [PluginType] {
        let typeIdentifier = ObjectIdentifier(PluginType.self)
        return self.plugins[typeIdentifier, default: []] as? [PluginType] ?? []
    }
}
