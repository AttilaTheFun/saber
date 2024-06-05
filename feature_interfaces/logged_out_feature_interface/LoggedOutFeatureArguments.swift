import DependencyFoundation
import UIKit

// @BuilderProvider(building: UIViewController.self)
// @Provider
public struct LoggedOutFeatureArguments {
    public init() {}
}

// TODO: Generate with @Provider macro.
public protocol LoggedOutFeatureArgumentsProvider {
    var loggedOutFeatureArguments: LoggedOutFeatureArguments { get }
}

// TODO: Generate with @BuilderProvider macro.
public protocol LoggedOutFeatureBuilderProvider {
    var loggedOutFeatureBuilder: any Builder<LoggedOutFeatureArguments, UIViewController> { get }
}
