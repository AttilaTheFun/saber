
/// The Type<T> class serves to signal the erased type to the @Factory and @Store macros.
/// 
/// This is required because the AccessorMacros do not allow themselves to be applied to classes.
/// 
/// TODO: Ask on Swift Evolution why this requirement exists and if there are better workarounds.
public final class Type<T> {
    public init() {}
}