import SaberTypes

/// The @Store macro can be applied to a property on a type annotated with the @Injector macro to generate a thread safe backing store.
@attached(accessor)
public macro Store<Concrete, Dependencies>(
    _ concrete: Concrete.Type,
    dependencies: Dependencies.Type = Any.self
) = #externalMacro(module: "SaberPlugin", type: "StoreMacro")
