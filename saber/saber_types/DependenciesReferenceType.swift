
public enum DependenciesReferenceType: String {

    /// The child will create a strong reference to its dependencies.
    case strong

    /// The child will create an unowned reference its dependencies.
    ///
    /// This is useful to avoid retain cycles. For example, if you have:
    /// ```
    /// FooScope -(Store)-> FooServiceImplementation
    /// FooServiceImplementation -(Dependencies)-> FooScope
    /// ```
    /// This would create a retain cycle.
    ///
    /// Making the reference from the FooServiceImplementation to the FooScope unowned would break this cycle.
    case unowned
}
