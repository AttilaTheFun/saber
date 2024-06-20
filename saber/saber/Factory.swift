
/// A Factory can produce a Value given an associated Arguments instance.
/// Calling the build function is thread-safe.
/// Every call to this function will receive a new instance of the Value type.
public protocol Factory<Arguments, Value> {
    associatedtype Arguments
    associatedtype Value
    func build(arguments: Arguments) -> Value
}

extension Factory where Arguments == Any {
    public func build() -> Value {
        return self.build(arguments: ())
    }
}
