import DependencyFoundation
import FooServiceInterface

// Expresses dependencies required to build an instance of the service implementation.
public typealias FooServiceImplementationDependencies
    = DependencyProvider

// Conforming to this protocol enables the receiver to conform to the FooServiceProvider protocol
// if it can provide the required dependencies.
public protocol FooServiceImplementationProvider {}
extension FooServiceImplementationProvider where Self: Scope & FooServiceProvider & FooServiceImplementationDependencies {
    public var fooService: any FooService {
        return self.shared {
            return FooServiceImplementation(dependencies: self)
        }
    }
}

public final class FooServiceImplementation: FooService {
    public init(dependencies: FooServiceImplementationDependencies) {}

    public func foo() async throws -> String {
        return "Bar"
    }
}