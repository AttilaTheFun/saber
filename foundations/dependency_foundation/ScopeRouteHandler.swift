
public protocol ScopeRouteHandler<Arguments> {
    associatedtype Arguments

    func handle(arguments: Arguments)
}

public final class ScopeRouteHandlerImplementation<Arguments>: ScopeRouteHandler {
    private let handler: (Arguments) -> Void

    public init(handler: @escaping (Arguments) -> Void) {
        self.handler = handler
    }

    public func handle(arguments: Arguments) {
        self.handler(arguments)
    }
}
