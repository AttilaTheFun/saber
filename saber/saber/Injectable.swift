
/// An Injectable type retains some set of Dependencies which are injected by a Scope.
public protocol Injectable<Dependencies> {
    associatedtype Dependencies
    var dependencies: Dependencies { get }
}
