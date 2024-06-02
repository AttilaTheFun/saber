import DependencyFoundation
import InitialScopeInterface

// TODO: Generate with @Buildable macro.
public final class InitialScopeImplementationBuilder: DependencyContainer<InitialScopeImplementationDependencies>, Builder {
    public func build(arguments: InitialScopeArguments) -> AnyObject {
        return InitialScopeImplementation(dependencies: self.dependencies, arguments: arguments)
    }
}

// TODO: Generate with @Injectable macro.
public typealias InitialScopeImplementationDependencies
    = DependencyProvider

// @Buildable(building: AnyObject.self)
// @Injectable
public final class InitialScopeImplementation: Scope<InitialScopeImplementationDependencies> {

    // @Arguments
    public let arguments: InitialScopeArguments

    // TODO: Generate with @Injectable macro.
    public init(dependencies: InitialScopeImplementationDependencies, arguments: InitialScopeArguments) {
        self.arguments = arguments
        super.init(dependencies: dependencies)
    }
}
