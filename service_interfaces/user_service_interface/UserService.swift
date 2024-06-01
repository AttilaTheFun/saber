
// @ServiceProvider
public protocol UserService {
    func getCurrentUser() async throws -> User
}

// TODO: Generate with @ServiceProvider macro.
public protocol UserServiceProvider {
    var userService: UserService { get }
}