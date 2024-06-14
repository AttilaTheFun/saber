
// TODO: Delete this in favor of factories.
public protocol Builder<Arguments, Building> {
    associatedtype Arguments
    associatedtype Building

    func build(arguments: Arguments) -> Building
}
