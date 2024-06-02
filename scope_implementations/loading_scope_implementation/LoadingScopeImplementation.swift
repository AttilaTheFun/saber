import DependencyFoundation
import LoadingScopeInterface

// TODO: Generate with @Buildable macro.
public final class LoadingScopeImplementationBuilder: DependencyContainer<LoadingScopeImplementationDependencies>, Builder {
    public func build(arguments: LoadingScopeArguments) -> AnyObject {
        return LoadingScopeImplementation(dependencies: self.dependencies, arguments: arguments)
    }
}

// TODO: Generate with @Injectable macro.
public typealias LoadingScopeImplementationDependencies
    = DependencyProvider

// @Buildable(building: AnyObject.self)
// @Injectable
public final class LoadingScopeImplementation: Scope<LoadingScopeImplementationDependencies> {

    // @Arguments
    public let arguments: LoadingScopeArguments

    // TODO: Generate with @Injectable macro.
    public init(dependencies: LoadingScopeImplementationDependencies, arguments: LoadingScopeArguments) {
        self.arguments = arguments
        super.init(dependencies: dependencies)
    }
}
