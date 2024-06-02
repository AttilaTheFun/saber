import DependencyFoundation
import FooServiceInterface

// TODO: Generate with @Injectable macro.
public typealias FooServiceImplementationDependencies
    = DependencyProvider

public final class FooServiceImplementation: FooService {

    // TODO: Generate with @Injectable macro.
    public init(dependencies: FooServiceImplementationDependencies) {}

    public func foo() async throws -> String {
        return "Bar"
    }
}
