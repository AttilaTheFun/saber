
/// The @Factory macro can be applied to a type property to ask the system to generate
/// a Factory property which can build instances of the concrete type erased to the property's type.
///
/// By default, the generated Factory will have an Arguments type of Void, 
/// and the concrete type is assumed not to require an arguments parameter in its initializer.
/// You can specify an Arguments type with a macro parameter.
///
/// Additionally, similar to the @Store macro, applying this macro to a type annotated with
/// the @Injectable macro will assume that the concrete type has an associated Dependencies protocol,
/// and add this to the peer type's ChildDependencies protocol.
/// 
/// Application:
/// ```
/// @Inject
/// final class FooScope: Scope, FooScopeChildDependencies {
///     @Factory(FooViewController.self, arguments: FooArguments.self)
///     let fooViewControllerType: UIViewController.Type
/// }
/// ```
/// 
/// Expansion:
/// ```
/// final class FooScope: Scope, FooScopeChildDependencies {
///     private let dependencies: FooScopeDependencies
///     let fooViewControllerType: UIViewController.Type
/// 
///     var fooViewControllerFactory: Factory<FooArguments, UIViewController> {
///         FactoryImplementation<FooArguments, UIViewController> { arguments in
///             FooViewController(arguments: arguments, dependencies: self)
///         }
///     }
/// 
///     init(dependencies: FooScopeDependencies) {
///         self.dependencies = dependencies
///         self.fooViewControllerType = FooViewController.self
///     }
/// }
/// 
/// protocol FooScopeDependencies {}
/// 
/// protocol FooScopeChildDependencies
///     : FooViewControllerDependencies
///     {}
/// 
/// ```
@attached(peer)
public macro Factory(
    _ concrete: Any.Type,
    arguments: Any.Type? = nil
) = #externalMacro(module: "DependencyMacrosPlugin", type: "FactoryMacro")
