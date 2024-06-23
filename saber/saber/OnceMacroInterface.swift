import SaberTypes

/// The @Once macro can be applied to a property to generate an adjacent
/// property of the Once type. 
/// 
/// This is useful for ensuring that a lazy property is only instantiated once
/// if it could be accessed for the first time simultaneously from multiple threads.
/// 
/// Usage:
/// ```
/// @Once
/// @Fulfill(FooServiceImplementationDependencies.self)
/// lazy var fooService: any FooService = self.fooServiceOnce { [unowned self] in
///     FooServiceImplementation(dependencies: self.fulfilledDependencies)
/// }
/// ```
@attached(peer, names: suffixed(Once))
public macro Once() = #externalMacro(module: "SaberPlugin", type: "OnceMacro")
