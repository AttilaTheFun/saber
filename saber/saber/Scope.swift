
/// A Scope retains dependencies with the same lifespan as the instance built by its root Factory.
public protocol Scope {
    associatedtype Arguments
    associatedtype Value
    var rootFactory: any Factory<Arguments, Value> { get }
}
