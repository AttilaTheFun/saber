
@attached(peer)
public macro Initialize(
    _ concreteType: Any.Type,
    argumentsType: Any.Type = Void.self
) = #externalMacro(module: "DependencyMacrosPlugin", type: "InitializeMacro")
