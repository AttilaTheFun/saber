
@attached(peer, names: suffixed(Builder))
public macro ViewControllerBuilder(
   arguments: Any.Type
) = #externalMacro(module: "DependencyMacrosPlugin", type: "ViewControllerBuilderMacro")
