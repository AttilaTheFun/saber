import DependencyFoundation
import UserServiceInterface

// TODO: Generate with @Injectable macro.
public typealias UserServiceImplementationDependencies
    = DependencyProvider

// @Injectable
public final class UserServiceImplementation: UserService {

    // TODO: Generate with @Injectable macro.
    public init(dependencies: UserServiceImplementationDependencies) {}

    public func getCurrentUser() async throws -> User {
        return User(id: 0, username: "username")
    }
}
