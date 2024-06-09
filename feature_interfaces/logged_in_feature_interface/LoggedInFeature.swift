import DependencyFoundation
import UIKit
import UserSessionServiceInterface
import UserServiceInterface

@BuilderProvider(UIViewController.self)
@Provider
public struct LoggedInFeature {
    public let userSession: UserSession
    public let user: User

    public init(userSession: UserSession, user: User) {
        self.userSession = userSession
        self.user = user
    }
}
