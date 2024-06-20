
/// The @Factory macro can be applied to an uninitialized `var` property of the Factory type,
/// on a type annotated with the @Injectable macro.
/// 
/// The macro expansion will generate a computed property that produces a Factory instance
/// capable of building instances of the concrete type when provided with instances of the arguments type.
/// 
/// The optional factory keypath argument allows the factory to build the concrete type 
/// as an intermediate value, and return an instance built from a nested factory.
@attached(accessor)
public macro Factory<T>(
    _ concrete: T.Type,
    factory: PartialKeyPath<T>? = nil
) = #externalMacro(module: "SaberPlugin", type: "FactoryMacro")
