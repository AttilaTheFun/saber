import DependencyFoundation
import UIKit
import UserSessionServiceInterface
import UserServiceInterface

// @BuilderProvider(building: UIViewController.self)
@Provider
public struct LoggedInFeatureArguments {
    public let userSession: UserSession
    public let user: User

    public init(userSession: UserSession, user: User) {
        self.userSession = userSession
        self.user = user
    }
}

// TODO: Generate with @BuilderProvider macro.
public protocol LoggedInFeatureBuilderProvider {
    var loggedInFeatureBuilder: any Builder<LoggedInFeatureArguments, UIViewController> { get }
}
