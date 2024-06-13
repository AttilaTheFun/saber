
// TODO: This could just be a typealias for the initializer function curried to include the dependencies.
public protocol Builder<Arguments, Building> {
    associatedtype Arguments
    associatedtype Building

    @discardableResult
    func build(arguments: Arguments) -> Building
}
