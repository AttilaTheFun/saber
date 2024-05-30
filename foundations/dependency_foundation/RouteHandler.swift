
// TODO: Get UIKit working.
//import UIKit
open class UIViewController {
    public init() {}
    public func present(_ viewController: UIViewController, animated: Bool) {}
}

public protocol RouteHandler<HandledRoute> {
    associatedtype HandledRoute: Route
    func destination(of route: HandledRoute) -> UIViewController
}