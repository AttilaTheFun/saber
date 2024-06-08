
@attached(peer, names: suffixed(Provider))
public macro Provider() =
    #externalMacro(module: "DependencyMacrosPlugin", type: "ProviderMacro")
