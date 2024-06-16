
public enum InjectableType: String {

    /// The strong injectable type is the default.
    /// It assumes the receiver is a concrete type without a supertype and as such will not have any required or designated initializers.
    /// This is used for Scope types and any other types which can strongly retain their dependencies.
    case strong

    /// The injectable type is a UIViewController subclass.
    /// This injectable type behaves the same as the strong type except it calls the designated initializer and implements the required initializer.
    case viewController

    /// The injectable type is a UIView subclass.
    /// This injectable type behaves the same as the strong type except it calls the designated initializer and implements the required initializer.
    case view

    /// The unowned injectable type is used for dependencies that are retained by a parent to avoid retain cycles.
    ///
    /// For example, if you have:
    /// ```
    /// FooScope -(store)-> FooServiceImplementation
    /// FooServiceImplementation -(dependencies)-> FooScope
    /// ```
    /// This would create a retain cycle.
    ///
    /// Applying @Injectable(.unowned) to the FooServiceImplementation will make the back reference unowned, breaking the cycle.
    case unowned
    // TODO: To prevent misuse, when applied, rename the Dependencies protocol to UnownedDependencies.
    // TODO: On the parent side, expect this protocol name in the ChildDependencies if an @Store type is strong.
    // TODO: This will result in a compile error if you try to use a strong store to hold a strong injectable.
}
