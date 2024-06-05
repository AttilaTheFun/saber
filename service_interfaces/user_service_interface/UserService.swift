import DependencyFoundation

// @Provider
public protocol UserService: AnyObject {
    func getCurrentUser() async throws -> User
}

// TODO: Generate with @Provider macro.
public protocol UserServiceProvider {
    var userService: UserService { get }
}
