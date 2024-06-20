import SaberTypes

/// The @Inject macro can be applied to an uninitialized `var` property of any type,
/// on a type annotated with the @Injectable macro.
/// 
/// The macro expansion will generate a backing Store that obtains and retains 
/// instances from the Dependencies of the receiver.
@attached(accessor)
public macro Inject(
    storage: StorageStrategy = .strong
) = #externalMacro(module: "SaberPlugin", type: "InjectMacro")
