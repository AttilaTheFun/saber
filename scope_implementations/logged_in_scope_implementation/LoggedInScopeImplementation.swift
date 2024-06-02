import DependencyFoundation
import LoggedInScopeInterface

// TODO: Generate with @Buildable macro.
public final class LoggedInScopeImplementationBuilder: DependencyContainer<LoggedInScopeImplementationDependencies>, Builder {
    public func build(arguments: LoggedInScopeArguments) -> AnyObject {
        return LoggedInScopeImplementation(dependencies: self.dependencies, arguments: arguments)
    }
}

// TODO: Generate with @Injectable macro.
public typealias LoggedInScopeImplementationDependencies
    = DependencyProvider

// @Buildable(building: AnyObject.self)
// @Injectable
final class LoggedInScopeImplementation: Scope<LoggedInScopeImplementationDependencies> {

    // @Arguments
    let arguments: LoggedInScopeArguments

    // TODO: Generate with @Injectable macro.
    init(dependencies: LoggedInScopeImplementationDependencies, arguments: LoggedInScopeArguments) {
        self.arguments = arguments
        super.init(dependencies: dependencies)
    }
}
