import DependencyFoundation
import UserSessionServiceInterface
import UserServiceInterface

// @RouterProvider
public struct LoggedInScopeArguments {
    public let userSession: UserSession
    public let user: User

    public init(userSession: UserSession, user: User) {
        self.userSession = userSession
        self.user = user
    }
}

// TODO: Generate with @RouterProvider macro.
public protocol LoggedInScopeRouterProvider {
    var loggedInScopeRouter: any Router<LoggedInScopeArguments> { get }
}