import SaberTypes

/// The @Injectable macro can be applied to any concrete type declaration which supports stored properties.
///
/// The macro also accepts the following optional arguments:
/// - super: The type of the superclass (if any) whose designated initializer must be called from the generated initializer. Defaults to nil.
/// - dependencies: The type of reference created between the injectable type and its dependencies. Defaults to strong.
///
/// The macro expansion generates initializers and properties to back the accessor macros:
/// - @Argument
/// - @Inject
@attached(member, names: arbitrary)
@attached(peer, names: suffixed(Dependencies), suffixed(UnownedDependencies))
@attached(extension, conformances: DependenciesInitializable)
public macro Injectable(
    _ super: Any.Type? = nil,
    dependencies: DependenciesReferenceType = .strong
) = #externalMacro(module: "SaberPlugin", type: "InjectableMacro")
