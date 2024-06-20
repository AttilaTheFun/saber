
public final class FactoryImplementation<Arguments, Building>: Factory {
    private let function: (Arguments) -> Building

    public init(_ function: @escaping (Arguments) -> Building) {
        self.function = function
    }

    public func build(arguments: Arguments) -> Building {
        return self.function(arguments)
    }
}
