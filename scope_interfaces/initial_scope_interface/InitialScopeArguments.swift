import DependencyFoundation
import UserSessionServiceInterface

// @BuilderProvider(building: AnyObject.self)
public struct InitialScopeArguments {
    public init() {}
}

// TODO: Generate with @BuilderProvider macro.
public protocol InitialScopeBuilderProvider {
    var initialScopeBuilder: any Builder<InitialScopeArguments, AnyObject> { get }
}
