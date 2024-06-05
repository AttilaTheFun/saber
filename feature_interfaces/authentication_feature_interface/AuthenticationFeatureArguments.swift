import DependencyFoundation
import UIKit

// @BuilderProvider(building: UIViewController.self)
public struct AuthenticationFeatureArguments {
    public init() {}
}

// TODO: Generate with @BuilderProvider macro.
public protocol AuthenticationFeatureBuilderProvider {
    var authenticationFeatureBuilder: any Builder<AuthenticationFeatureArguments, UIViewController> { get }
}