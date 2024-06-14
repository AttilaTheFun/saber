import DependencyMacrosTypes

/// The @Store macro can be applied to an uninitialized `var` property of any type to generate
/// a `get` accessor for the property which initializes and stores a factory that builds the concrete type.
///
/// Application:
/// ```
/// final class FooParent {
///     @Store(FooServiceImplementation.self)
///     var fooService: any FooService
/// }
/// ```
///
/// Expansion:
/// ```
/// final class FooParent {
///     var fooService: any FooService {
///         get {
///             self.strong { [unowned self] in
///                 FooServiceImplementation(dependencies: self)
///             }
///         }
///     }
/// }
/// ```
@attached(accessor)
public macro Store(
    _ concrete: Any.Type,
    init: InitializationStrategy = .lazy,
    ref: ReferenceStrategy = .strong
) = #externalMacro(module: "DependencyMacrosPlugin", type: "StoreMacro")
