import DependencyMacrosTypes

/// The @Argument macro can be applied to an uninitialized `var` property of any type,
/// on a type annotated with the @Injectable macro.
/// 
/// The macro expansion will retrieve the value from the Arguments of the receiver.
@attached(accessor)
public macro Argument(
    storage: StorageStrategy = .strong
) = #externalMacro(module: "DependencyMacrosPlugin", type: "ArgumentMacro")
