

@attached(peer)
public macro FactoryBuilder() =
    #externalMacro(module: "DependencyMacrosPlugin", type: "FactoryBuilderMacro")
