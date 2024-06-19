
public enum DependenciesReferenceType: String {

    /// The child will create a strong reference to its dependencies.
    case strong

    /// The child will create an unowned reference its dependencies.
    /// This is useful to avoid retain cycles.
    ///
    /// For example, if you have:
    /// ```
    /// FooScope -(store)-> FooServiceImplementation
    /// FooServiceImplementation -(dependencies)-> FooScope
    /// ```
    /// This would create a retain cycle.
    ///
    /// Making the reference from the FooServiceImplementation to the FooScope unowned would break this cycle.
    case unowned
    // TODO: To prevent misuse, when applied, rename the Dependencies protocol to UnownedDependencies.
    // TODO: On the parent side, expect this protocol name in the ChildDependencies if an @Store type is strong.
    // TODO: This will result in a compile error if you try to use a strong store to hold a strong injectable.
}
