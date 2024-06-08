import DependencyFoundation

@Provider
public protocol UserService: AnyObject {
    func getCurrentUser() async throws -> User
}

