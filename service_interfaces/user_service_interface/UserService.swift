import DependencyFoundation

// @ServiceProvider
public protocol UserService {
    func getCurrentUser() async throws -> User
}

// TODO: Generate with @ServiceProvider macro.
public protocol UserServiceProvider {
    var userService: UserService { get }
}

// TODO: Generate with @ServiceProvider macro with ability to opt out of automatic propagation.
extension DependencyContainer: UserServiceProvider where Dependencies: UserServiceProvider {
    public var userService: any UserService {
        return self.dependencies.userService
    }
}
