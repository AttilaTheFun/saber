import DependencyFoundation
import UIKit

// @BuilderProvider(building: UIViewController.self)
public struct LoadingFeatureArguments {
    public init() {}
}

// TODO: Generate with @BuilderProvider macro.
public protocol LoadingFeatureBuilderProvider {
    var loadingFeatureBuilder: any Builder<LoadingFeatureArguments, UIViewController> { get }
}