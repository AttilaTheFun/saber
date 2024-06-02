import BarServiceInterface
import FooServiceInterface
import DependencyFoundation

// TODO: Generate with @Injectable macro.
public typealias BarServiceImplementationDependencies
    = DependencyProvider
    & FooServiceProvider

// @Injectable
public final class BarServiceImplementation: BarService {

    // @Inject
    private let fooService: FooService

    // TODO: Generate with @Injectable macro.
    public init(dependencies: BarServiceImplementationDependencies) {
        self.fooService = dependencies.fooService
    }

    public func bar() async throws -> String {
        let fooID = try await self.fooService.foo()
        return fooID
    }
}
