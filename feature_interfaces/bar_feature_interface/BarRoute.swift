import DependencyFoundation

public struct BarRoute: Route {
    public let barID: String

    public init(barID: String) {
        self.barID = barID
    }
}

// TODO: Add @Route macro which generates handler provider protocol.

public protocol BarRouteHandlerProvider {
    var barRouteHandler: any RouteHandler<BarRoute> { get }
}