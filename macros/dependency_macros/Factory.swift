
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
/// Usage:
/// ```
/// @Inject
/// final class FooScope: Scope, FooScopeChildDependencies {
///     @Factory(FooViewController.self, arguments: FooArguments.self)
///     let fooViewControllerType: UIViewController.Type
/// }
/// ```
@attached(peer)
public macro Factory(_ concrete: Any.Type, arguments: Any.Type? = nil, scope: Any.Type? = nil) =
    #externalMacro(module: "DependencyMacrosPlugin", type: "FactoryMacro")
