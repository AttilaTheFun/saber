import DependencyMacrosTypes

@attached(accessor)
public macro Inject(
    access: AccessStrategy = .computed
) = #externalMacro(module: "DependencyMacrosPlugin", type: "InjectMacro")
