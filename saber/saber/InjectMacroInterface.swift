import SaberTypes

/// The @Inject macro can be applied to an uninitialized `var` property of any type,
/// on a type annotated with the @Injectable macro.
/// 
/// The macro expansion read the property from the property of the Dependencies type.
@attached(accessor)
public macro Inject() = #externalMacro(module: "SaberPlugin", type: "InjectMacro")
