
/// The strategy employed for the reference to a property annotated with the @Store macro.
/// 
/// Usage:
/// ```
/// @Store(FooServiceImplementation.swift, ref: .weak)
/// let fooServiceType: FooService.Type
/// ````
public enum ReferenceStrategy: String {

    // The initialized object is retained strongly.
    // Repeated access to the same property will return the same value.
    case strong

    // The initialized object is retained weakly.
    // Repeated access to the same property will return the same value until it is released.
    // Once the object has been released, the next call will create a new instance.
    case weak
}