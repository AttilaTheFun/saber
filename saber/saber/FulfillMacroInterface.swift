import SaberTypes

/// The @Fulfill macro can be applied to a property on a type annotated with the @Scope macro
/// to request that its FulfilledDependencies object fulfills the requirements specified via the given Dependencies protocol.
@attached(peer)
public macro Fulfill(
    _ dependencies: Any.Type?
) = #externalMacro(module: "SaberPlugin", type: "FulfillMacro")
