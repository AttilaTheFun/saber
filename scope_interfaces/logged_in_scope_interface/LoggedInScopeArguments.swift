import DependencyFoundation
import UserSessionServiceInterface
import UserServiceInterface

// @BuilderProvider(building: AnyObject.self)
// @Provider
public struct LoggedInScopeArguments {
    public let userSession: UserSession
    public let user: User

    public init(userSession: UserSession, user: User) {
        self.userSession = userSession
        self.user = user
    }
}

// TODO: Generate with @Provider macro.
public protocol LoggedInScopeArgumentsProvider {
    var loggedInScopeArguments: LoggedInScopeArguments { get }
}

// TODO: Generate with @BuilderProvider macro.
public protocol LoggedInScopeBuilderProvider {
    var loggedInScopeBuilder: any Builder<LoggedInScopeArguments, AnyObject> { get }
}
