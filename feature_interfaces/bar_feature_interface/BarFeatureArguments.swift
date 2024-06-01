import DependencyFoundation
import UIKit

// @BuilderProvider(building: UIViewController.self)
public struct BarFeatureArguments {
    public let barID: String
    public let other: Int

    public init(barID: String, other: Int) {
        self.barID = barID
        self.other = other
    }
}

// TODO: Generate with @BuilderProvider macro.
public protocol BarFeatureBuilderProvider {
    var barFeatureBuilder: any Builder<BarFeatureArguments, UIViewController> { get }
}