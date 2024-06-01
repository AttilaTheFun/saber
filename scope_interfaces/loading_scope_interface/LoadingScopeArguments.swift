import DependencyFoundation
import UserSessionServiceInterface

// @RouterProvider
public struct LoadingScopeArguments {
    public let userSession: UserSession

    public init(userSession: UserSession) {
        self.userSession = userSession
    }
}

// TODO: Generate with @RouterProvider macro.
public protocol LoadingScopeRouterProvider {
    var loadingScopeRouter: any Router<LoadingScopeArguments> { get }
}