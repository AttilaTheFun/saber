
public protocol Builder<Arguments, Building> {
    associatedtype Arguments
    associatedtype Building

    @discardableResult
    func build(arguments: Arguments) -> Building
}
