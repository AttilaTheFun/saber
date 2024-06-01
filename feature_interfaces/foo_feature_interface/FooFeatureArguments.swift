import DependencyFoundation
import UIKit

// @BuilderProvider(building: UIViewController.self)
public struct FooFeatureArguments {
    public let fooID: String

    public init(fooID: String) {
        self.fooID = fooID
    }
}

// TODO: Generate with @BuilderProvider macro.
public protocol FooFeatureBuilderProvider {
    var fooFeatureBuilder: any Builder<FooFeatureArguments, UIViewController> { get }
}