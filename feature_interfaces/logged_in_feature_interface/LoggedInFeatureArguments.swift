import DependencyFoundation
import UIKit

// @BuilderProvider(building: UIViewController.self)
public struct LoggedInFeatureArguments {
    public init() {}
}

// TODO: Generate with @BuilderProvider macro.
public protocol LoggedInFeatureBuilderProvider {
    var loggedInFeatureBuilder: any Builder<LoggedInFeatureArguments, UIViewController> { get }
}