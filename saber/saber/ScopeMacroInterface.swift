import SaberTypes

/// The @Scope macro can be applied to a concrete type which supports stored properties.
/// It generates a FulfilledDependencies protocol from @Fullfill properties,
/// as well as an initializer which accepts arguments and dependencies.
@attached(member, names: arbitrary)
@attached(peer, names: suffixed(FulfilledDependencies))
@attached(extension, conformances: ArgumentsAndDependenciesInitializable)
public macro Scope() = #externalMacro(module: "SaberPlugin", type: "ScopeMacro")
