import SaberTypes

/// The @Store macro can be applied to a property on a type annotated with the @Scope macro to generate a thread safe backing store.
@attached(accessor)
public macro Store<T>(_ concrete: T.Type) = #externalMacro(module: "SaberPlugin", type: "StoreMacro")
