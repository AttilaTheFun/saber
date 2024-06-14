
/// The strategy employed for the initialization of a property annotated with the @Store macro.
public enum InitializationStrategy: String {

    // The initializer is run lazily.
    case lazy

    // The initializer is run eagerly.
    case eager
}
