import DependencyFoundation

public struct FooRoute: Route {
    public let fooID: String

    public init(fooID: String) {
        self.fooID = fooID
    }
}

// TODO: Add @Route macro which generates handler provider protocol.

public protocol FooRouteHandlerProvider {
    var fooRouteHandler: any RouteHandler<FooRoute> { get }
}