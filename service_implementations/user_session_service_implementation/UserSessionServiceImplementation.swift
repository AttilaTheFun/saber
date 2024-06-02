import DependencyFoundation
import UserSessionServiceInterface

// TODO: Generate with @Injectable macro.
public typealias UserSessionServiceImplementationDependencies
    = DependencyProvider

// @Injectable
public final class UserSessionServiceImplementation: UserSessionService {
    
    // TODO: Generate with @Injectable macro.
    public init(dependencies: UserSessionServiceImplementationDependencies) {}

    public func createSession(username: String, password: String) async throws -> UserSession {
        return UserSession(id: 1, userID: 1, token: "token")
    }

    public func deleteSession(id: UInt64) async throws {
    }
}
