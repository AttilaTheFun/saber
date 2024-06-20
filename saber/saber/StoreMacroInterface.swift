import SaberTypes

/// The @Store macro can be applied to an uninitialized `var` property of any type,
/// on a type annotated with the @Injectable macro.
/// 
/// The macro expansion will generate a backing Store that initializes 
/// and retains instances of the concrete type.
@attached(accessor)
public macro Store(
    _ concrete: Any.Type,
    storage: StorageStrategy = .strong,
    init: InitializationStrategy = .lazy
) = #externalMacro(module: "SaberPlugin", type: "StoreMacro")
