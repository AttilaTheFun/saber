
 @attached(peer, names: suffixed(BuilderProvider))
 public macro BuilderProvider(
    _: Any.Type
 ) = #externalMacro(module: "DependencyMacrosPlugin", type: "BuilderProviderMacro")

@attached(peer, names: suffixed(Provider))
public macro Provider() =
    #externalMacro(module: "DependencyMacrosPlugin", type: "ProviderMacro")
