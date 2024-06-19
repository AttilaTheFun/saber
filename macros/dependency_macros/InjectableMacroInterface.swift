import DependencyMacrosTypes

/// The @Injectable macro can be applied to any concrete type declaration which supports stored properties.
///
/// This macro accepts optional arguments:
/// - arguments: The type of the arguments required to instantiate the injectable type, if any.
/// - super: The type of the superclass whose initializer must be called from the generated initializer, if any.
/// - dependencies: The type of reference created between the injectable type and its dependencies. Defaults to strong.
///
/// The macro expansion generates initializers and properties to back the accessor macros:
/// - @Arguments
/// - @Argument
/// - @Factory
/// - @Inject
/// - @Store
@attached(member, names: arbitrary)
@attached(peer, names: suffixed(Dependencies), suffixed(ChildDependencies))
@attached(extension, conformances: Injectable)
public macro Injectable(
    super: Any.Type? = nil,
    dependencies: DependenciesReferenceType = .strong
) = #externalMacro(module: "DependencyMacrosPlugin", type: "InjectableMacro")
