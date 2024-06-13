
/// The @Injectable macro can be applied to any nominal type which supports stored properties (actor, class or struct).
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
///
/// The @Arguments and @Inject macros are used to signal to the @Injectable macro that these properties should be injected.
/// Zero or one arguments properties may be provided, and zero or more injected properties may be provided.
///
/// The @Injectable macro uses this information to generate the following declarations:
/// - A Dependencies protocol with members for each injected property.
/// - A private dependencies stored property of the same type.
/// - An initializer which accepts the dependencies and an arguments parameter if annotated, and initializes the respective properties with their values.
///
/// The Dependencies protocol, initializer and stored property are always generated in @Injectable is applied even if they are otherwise unused.
/// This is intentional because there may be dependencies instantiated and retained by the Scope abstracted through the Dependencies protocol.
@attached(member, names: arbitrary)
@attached(peer, names: suffixed(Dependencies))
public macro Injectable() =
    #externalMacro(module: "DependencyMacrosPlugin", type: "InjectableMacro")

/// A variant of the @Injectable macro for view controllers which calls the designated initializer, `super.init(nibName: nil, bundle: nil)`,
/// from the generated initializer, and implements the required initializer `init?(coder: NSCoder)` with a `fatalError()`.
@attached(member, names: arbitrary)
@attached(peer, names: suffixed(Dependencies))
public macro ViewControllerInjectable() =
    #externalMacro(module: "DependencyMacrosPlugin", type: "ViewControllerInjectableMacro")

/// A variant of the @Injectable macro for view controllers which calls the designated initializer, `super.init(nibName: nil, bundle: nil)`,
/// from the generated initializer, and implements the required initializer `init?(coder: NSCoder)` with a `fatalError()`.
@attached(member, names: arbitrary)
@attached(peer, names: suffixed(Dependencies))
public macro ScopeInjectable() =
    #externalMacro(module: "DependencyMacrosPlugin", type: "ScopeInjectableMacro")
