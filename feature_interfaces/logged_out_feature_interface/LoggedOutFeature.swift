import DependencyFoundation
import UIKit

@BuilderProvider(UIViewController.self)
@Provider
public struct LoggedOutFeature {
    public init() {}
}
