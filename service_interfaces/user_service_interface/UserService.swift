import DependencyMacros

public protocol UserService: AnyObject {
    func getCurrentUser() async throws -> User
}

