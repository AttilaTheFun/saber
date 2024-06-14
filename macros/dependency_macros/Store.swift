import DependencyMacrosTypes

@attached(peer)
public macro Store(
    _ concreteType: Any.Type,
    argumentsType: Any.Type = Void.self
) = #externalMacro(module: "DependencyMacrosPlugin", type: "StoreMacro")
