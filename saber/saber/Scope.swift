
/// A Scope type retains some set of Arguments and fulfills the Dependencies of Injectable types.
public protocol Scope<Arguments> {
    associatedtype Arguments
    var arguments: Arguments { get }
}
