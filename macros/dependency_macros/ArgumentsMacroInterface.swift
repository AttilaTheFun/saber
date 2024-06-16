
/// The @Arguments macro can be attached to up to one var property,
/// without an initializer, on an @Injectable class.
@attached(accessor)
public macro Arguments() =
    #externalMacro(module: "DependencyMacrosPlugin", type: "ArgumentsMacro")
