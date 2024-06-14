import DependencyMacrosTypes

@attached(peer)
@attached(accessor)
public macro Store(
    _ concrete: Any.Type,
    init: InitializationStrategy = .lazy,
    ref: ReferenceStrategy = .strong
) = #externalMacro(module: "DependencyMacrosPlugin", type: "StoreMacro")
