import BarServiceInterface
import FooServiceInterface
import DependencyFoundation

public typealias BarServiceDependencies
    = DependencyProvider
    & FooServiceProvider

public final class BarServiceImplementation: BarService {
    private let fooService: FooService

    public init(dependencies: BarServiceDependencies) {
        self.fooService = dependencies.fooService
    }

    public func bar() async throws {
        let barID = try await self.fooService.foo()
        print(barID)
    }
}