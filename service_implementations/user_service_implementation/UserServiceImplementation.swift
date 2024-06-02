import DependencyFoundation
import UserServiceInterface

public final class UserServiceImplementation: UserService {
    init() {}

    public func getCurrentUser() async throws -> User {
        return User(id: 0, username: "username")
    }
}
