import DependencyFoundation

// @BuilderProvider(building: AnyObject.self)
public struct LoggedOutScopeArguments {
    public init() {}
}

// TODO: Generate with @BuilderProvider macro.
public protocol LoggedOutScopeBuilderProvider {
    var loggedOutScopeBuilder: any Builder<LoggedOutScopeArguments, AnyObject> { get }
}
