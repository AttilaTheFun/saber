import SaberTypes

/// The @Injectable macro can be applied to a concrete type which supports stored properties.
/// It generates a Dependencies protocol from @Inject properties,
/// as well as an initializer which accepts dependencies.
@attached(member, names: arbitrary)
@attached(peer, names: suffixed(Dependencies), suffixed(UnownedDependencies))
@attached(extension, conformances: Injectable)
public macro Injectable(
    _ super: Any.Type? = nil,
    dependencies: DependenciesReferenceType = .strong
) = #externalMacro(module: "SaberPlugin", type: "InjectableMacro")
