
public enum ChildDependenciesReferenceType: String {

    /// The parent will create a weak reference its child dependencies.
    case weak

    /// The child will create an strong reference its child dependencies.
    /// This is useful for the root scope which does not have an object to retain the child dependencies.
    case strong
}
