
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

public final class FactoryImplementation<Arguments, Building>: Factory {
    private let function: (Arguments) -> Building

    public init(_ function: @escaping (Arguments) -> Building) {
        self.function = function
    }

    public func build(arguments: Arguments) -> Building {
        return self.function(arguments)
    }
}
