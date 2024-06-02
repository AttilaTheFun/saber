import DependencyFoundation

// @ServiceProvider
public protocol FooService {
    func foo() async throws -> String
}

// TODO: Generate with @ServiceProvider macro.
public protocol FooServiceProvider {
    var fooService: any FooService { get }
}

// TODO: Generate with @ServiceProvider macro with ability to opt out of automatic propagation.
extension DependencyContainer: FooServiceProvider where Dependencies: FooServiceProvider {
    public var fooService: any FooService {
        return self.dependencies.fooService
    }
}