
/// This macro can be applied to any nominal type to generate an associated provider protocol.
///
/// For example, when applied to the protocol `FooService`:
/// ```
/// @Provider
/// public protocol FooService {
///     ...
/// }
/// ```
///
/// The macro expands to:
/// ```
/// public protocol FooService {
///     ...
/// }
///
/// public protocol FooProvider {
///     var fooService: FooService { get }
/// }
/// ```
///
/// NOTE: The the name of the property matches that of the nominal type with a lowercase first letter.
/// NOTE: The generated protocol is always public.
@attached(peer, names: suffixed(Provider))
public macro Provider() =
    #externalMacro(module: "DependencyMacrosPlugin", type: "ProviderMacro")
