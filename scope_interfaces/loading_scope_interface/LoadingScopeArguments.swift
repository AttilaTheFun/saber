import DependencyFoundation
import UserSessionServiceInterface

// @BuilderProvider(building: AnyObject.self)
public struct LoadingScopeArguments {
    public let userSession: UserSession

    public init(userSession: UserSession) {
        self.userSession = userSession
    }
}

// TODO: Generate with @BuilderProvider macro.
public protocol LoadingScopeBuilderProvider {
    var loadingScopeBuilder: any Builder<LoadingScopeArguments, AnyObject> { get }
}
