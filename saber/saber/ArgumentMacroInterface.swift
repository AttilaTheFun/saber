import SaberTypes

/// The @Argument macro can be applied to an uninitialized `var` property of any type,
/// on a type annotated with the @Injector macro.
///
/// The macro expansion read the value from the property of the Arguments type.
@attached(accessor)
public macro Argument() = #externalMacro(module: "SaberPlugin", type: "ArgumentMacro")
