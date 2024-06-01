
// @ServiceProvider
public protocol FooService {
    func foo() async throws -> String
}

// TODO: Generate with @ServiceProvider macro.
public protocol FooServiceProvider {
    var fooService: any FooService { get }
}