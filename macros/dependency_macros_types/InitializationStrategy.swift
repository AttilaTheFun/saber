
/// The strategy employed for the initialization of a property annotated with the @Store macro.
/// 
/// Usage:
/// ```
/// @Store(FooServiceImplementation.swift, init: .eager)
/// let fooServiceType: FooService.Type
/// ````
public enum InitializationStrategy: String {

    // The initializer is run eagerly.
    case eager

    // The initializer is run lazily.
    case lazy
}
