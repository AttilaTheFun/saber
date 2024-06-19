
/// A Scope retains dependencies with the same lifespan as the instance built by its root Factory.
public protocol Scope<Arguments, Value> {
    associatedtype Arguments
    associatedtype Value
    var rootFactory: Factory<Arguments, Value> { get }
}