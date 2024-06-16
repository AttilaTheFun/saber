import DependencyMacrosTypes

/// The @Injectable macro can be applied to any concrete type declaration which supports stored properties.
///
/// The macro expansion generates initializers and stored properties to back the 
/// @Arguments, @Factory, @Inject, and @Store macros.
@attached(member, names: arbitrary)
@attached(peer, names: suffixed(Dependencies), suffixed(ChildDependencies))
public macro Injectable(
    _ injectableType: InjectableType = .strong
) = #externalMacro(module: "DependencyMacrosPlugin", type: "InjectableMacro")
