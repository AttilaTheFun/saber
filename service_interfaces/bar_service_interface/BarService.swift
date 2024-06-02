import DependencyFoundation

// @ServiceProvider
public protocol BarService {
    func bar() async throws -> String
}

// TODO: Generate with @ServiceProvider macro.
public protocol BarServiceProvider {
    var barService: any BarService { get }
}
