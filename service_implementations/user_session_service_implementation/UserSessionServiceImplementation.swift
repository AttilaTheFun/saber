import DependencyFoundation
import UserSessionServiceInterface

public final class UserSessionServiceImplementation: UserSessionService {
    init() {}

    public func createSession(username: String, password: String) async throws -> UserSession {
        return UserSession(id: 1, userID: 1, token: "token")
    }

    public func deleteSession(id: UInt64) async throws {
    }
}
