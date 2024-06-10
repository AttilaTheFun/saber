
@attached(peer, names: suffixed(Builder))
public macro ScopeViewControllerBuilder(
   arguments: Any.Type
) = #externalMacro(module: "DependencyMacrosPlugin", type: "ScopeViewControllerBuilderMacro")
