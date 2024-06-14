
/// The @Injectable macro can be applied to any concrete type declaration which supports stored properties (actor, class or struct).
///
/// Usage:
///
/// ```
/// @Injectable
/// final class FooObjectImplementation {
///     @Arguments let fooArguments: FooArguments
///     @Inject let fooService: FooService
///     @Inject let barService: BarService
/// }
/// ```
@attached(member, names: arbitrary)
@attached(peer, names: suffixed(Dependencies), suffixed(ChildDependencies))
public macro Injectable() = #externalMacro(module: "DependencyMacrosPlugin", type: "InjectableMacro")
