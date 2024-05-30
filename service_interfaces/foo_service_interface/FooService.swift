
public protocol FooService {
    func foo() async throws
}

public protocol FooServiceProvider {
    var fooService: FooService { get }
}