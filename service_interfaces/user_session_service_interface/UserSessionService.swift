
// @ServiceProvider
public protocol UserSessionService {
    func createSession(username: String, password: String) async throws -> UserSession
    func deleteSession(id: UInt64) async throws
}

// TODO: Generate with @ServiceProvider macro.
public protocol UserSessionServiceProvider {
    var userSessionService: UserSessionService { get }
}