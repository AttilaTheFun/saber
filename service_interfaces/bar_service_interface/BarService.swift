import DependencyFoundation

// @ServiceProvider
public protocol BarService {
    func bar() async throws -> String
}

// TODO: Generate with @ServiceProvider macro.
public protocol BarServiceProvider {
    var barService: any BarService { get }
}

// TODO: Generate with @ServiceProvider macro with ability to opt out of automatic propagation.
extension DependencyContainer: BarServiceProvider where Dependencies: BarServiceProvider {
    public var barService: any BarService {
        return self.dependencies.barService
    }
}