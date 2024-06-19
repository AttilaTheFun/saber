
/// A Factory can produce a Building given an associated Arguments instance.
/// Calling the build function is thread-safe.
/// Every call to this function will receive a new instance of the Building type.
public protocol Factory<Arguments, Building> {
    associatedtype Arguments
    associatedtype Building

    func build(arguments: Arguments) -> Building
}

extension Factory where Arguments == Void {
    public func build() -> Building {
        return self.build(arguments: ())
    }
}
