
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
