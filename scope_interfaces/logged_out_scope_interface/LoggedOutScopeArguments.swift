import DependencyFoundation

// @RouterProvider
public struct LoggedOutScopeArguments {
    public init() {}
}

// TODO: Generate with @RouterProvider macro.
public protocol LoggedOutScopeRouterProvider {
    var loggedOutScopeRouter: any Router<LoggedOutScopeArguments> { get }
}