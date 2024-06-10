
/// This macro can be applied to any concrete nominal type to generate an associated builder provider protocol.
///
/// For example, when applied to the struct `FooFeature`:
/// ```
/// @BuilderProvider
/// public struct FooFeature {
///     ...
/// }
/// ```
///
/// The macro expands to:
/// ```
/// public struct FooFeature {
///     ...
/// }
///
/// public protocol FooFeatureBuilderProvider {
///     var fooFeatureBuilder: any Builder<FooFeature, UIViewController> { get }
/// }
/// ```
///
/// NOTE: The type to which the macro is applied becomes the Builder's Arguments type.
/// NOTE: The the name of the property matches that of the arguments type with a lowercase first letter and the ViewControllerBuilder suffix.
/// NOTE: The generated protocol is always public.
@attached(peer, names: suffixed(BuilderProvider))
public macro BuilderProvider() = #externalMacro(module: "DependencyMacrosPlugin", type: "BuilderProviderMacro")

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

@attached(peer, names: suffixed(Builder))
public macro ScopeViewControllerBuilder(
   arguments: Any.Type
) = #externalMacro(module: "DependencyMacrosPlugin", type: "ScopeViewControllerBuilderMacro")

@attached(peer, names: suffixed(Builder))
public macro ViewControllerBuilder(
   arguments: Any.Type
) = #externalMacro(module: "DependencyMacrosPlugin", type: "ViewControllerBuilderMacro")
