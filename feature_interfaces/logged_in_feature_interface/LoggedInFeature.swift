import DependencyFoundation
import DependencyMacros
import UIKit
import UserSessionServiceInterface
import UserServiceInterface

@Provider
@BuilderProvider
public struct LoggedInFeature {
    public let userSession: UserSession
    public let user: User

    public init(userSession: UserSession, user: User) {
        self.userSession = userSession
        self.user = user
    }
}
