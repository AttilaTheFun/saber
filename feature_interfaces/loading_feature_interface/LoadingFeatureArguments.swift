import DependencyFoundation
import UIKit
import UserSessionServiceInterface

// @BuilderProvider(building: UIViewController.self)
@Provider
public struct LoadingFeatureArguments {
    public let userSession: UserSession

    public init(userSession: UserSession) {
        self.userSession = userSession
    }
}

// TODO: Generate with @BuilderProvider macro.
public protocol LoadingFeatureBuilderProvider {
    var loadingFeatureBuilder: any Builder<LoadingFeatureArguments, UIViewController> { get }
}
