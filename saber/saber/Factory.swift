
/// A Factory can produce a Building instance given an associated Arguments instance.
/// Calling the build function is thread-safe.
/// Every call to this function will receive a new instance of the Building type.
public final class Factory<Arguments, Building> {
    private let function: (Arguments) -> Building

    public init(_ function: @escaping (Arguments) -> Building) {
        self.function = function
    }

    public func build(arguments: Arguments) -> Building {
        return self.function(arguments)
    }
}

extension Factory where Arguments == Void {
    public convenience init(_ function: @escaping () -> Building) {
        self.init { _ in
            function()
        }
    }

    public func build(arguments: Any) -> Building {
        return self.build(arguments: ())
    }

    public func build() -> Building {
        return self.build(arguments: ())
    }
}
