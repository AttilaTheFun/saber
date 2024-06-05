import DependencyFoundation

// @BuilderProvider(building: AnyObject.self)
// @Provider
public struct LoggedOutScopeArguments {
    public init() {}
}

// TODO: Generate with @Provider macro.
public protocol LoggedOutScopeArgumentsProvider {
    var loggedOutScopeArguments: LoggedOutScopeArguments { get }
}

// TODO: Generate with @BuilderProvider macro.
public protocol LoggedOutScopeBuilderProvider {
    var loggedOutScopeBuilder: any Builder<LoggedOutScopeArguments, AnyObject> { get }
}
