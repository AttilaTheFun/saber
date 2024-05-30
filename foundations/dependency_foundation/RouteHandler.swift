
// TODO: Get UIKit working.
//import UIKit
@MainActor
open class UIViewController {
    public init() {}
    public func present(_ viewController: UIViewController, animated: Bool) {}
}

@MainActor
public protocol RouteHandler<HandledRoute> {
    associatedtype HandledRoute: Route
    func destination(of route: HandledRoute) -> UIViewController
}