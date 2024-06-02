import DependencyFoundation
import UserSessionServiceInterface
import UserServiceInterface

// @BuilderProvider(building: AnyObject.self)
public struct LoggedInScopeArguments {
    public let userSession: UserSession
    public let user: User

    public init(userSession: UserSession, user: User) {
        self.userSession = userSession
        self.user = user
    }
}

// TODO: Generate with @BuilderProvider macro.
public protocol LoggedInScopeBuilderProvider {
    var loggedInScopeBuilder: any Builder<LoggedInScopeArguments, AnyObject> { get }
}
