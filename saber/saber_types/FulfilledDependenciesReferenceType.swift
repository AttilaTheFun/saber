
public enum FulfilledDependenciesReferenceType: String {

    /// The parent will create a weak reference its fulfilled dependencies.
    case weak

    /// The child will create an strong reference its fulfilled dependencies.
    /// This is useful for the root scope which does not have an object to retain the fulfilled dependencies.
    case strong
}
