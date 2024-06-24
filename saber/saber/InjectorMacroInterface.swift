import SaberTypes

/// The @Injector macro can be applied to a concrete type which supports stored properties.
/// It generates a FulfilledDependencies protocol from @Fullfill properties,
/// as well as an initializer which accepts arguments and dependencies.
@attached(member, names: arbitrary)
@attached(peer, names: suffixed(FulfilledDependencies))
public macro Injector() = #externalMacro(module: "SaberPlugin", type: "InjectorMacro")
