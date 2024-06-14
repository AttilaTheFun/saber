
/// The @Factory macro can be applied to an uninitialized `var` property of the Factory type to generate
/// a `get` accessor for the property which initializes and returns a factory that builds the concrete type.
///
/// Application:
/// ```
/// final class FooParent {
///     @Factory(FooViewController.self)
///     var fooViewControllerFactory: Factory<FooArguments, UIViewController>
/// }
/// ```
///
/// Expansion:
/// ```
/// final class FooParent {
///     var fooViewControllerFactory: Factory<FooArguments, UIViewController> {
///         get {
///             FactoryImplementation { arguments in
///                 FooViewController(arguments: arguments, dependencies: self)
///             }
///         }
///     }
/// }
/// ```
@attached(accessor)
public macro Factory<T>(
    _ concrete: T.Type,
    factory: PartialKeyPath<T>? = nil
) = #externalMacro(module: "DependencyMacrosPlugin", type: "FactoryMacro")
