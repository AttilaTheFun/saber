import BarServiceInterface
import FooServiceInterface
import DependencyFoundation

// Expresses dependencies required to build an instance of the service implementation.
public typealias BarServiceImplementationDependencies
    = DependencyProvider
    & FooServiceProvider

// Conforming to this protocol enables the receiver to conform to the BarServiceProvider protocol
// if it can provide the required dependencies.
public protocol BarServiceImplementationProvider {}
extension BarServiceImplementationProvider where Self: Scope & BarServiceProvider & BarServiceImplementationDependencies {
    public var barService: any BarService {
        return self.new {
            return BarServiceImplementation(dependencies: self)
        }
    }
}

public final class BarServiceImplementation: BarService {
    private let fooService: FooService

    public init(dependencies: BarServiceImplementationDependencies) {
        self.fooService = dependencies.fooService
    }

    public func bar() async throws {
        let barID = try await self.fooService.foo()
        print(barID)
    }
}