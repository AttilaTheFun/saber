import DependencyFoundation

// @ServiceProvider
public protocol UserSessionService {
    func createSession(username: String, password: String) async throws -> UserSession
    func deleteSession(id: UInt64) async throws
}

// TODO: Generate with @ServiceProvider macro.
public protocol UserSessionServiceProvider {
    var userSessionService: UserSessionService { get }
}

// TODO: Generate with @ServiceProvider macro with ability to opt out of automatic propagation.
extension DependencyContainer: UserSessionServiceProvider where Dependencies: UserSessionServiceProvider {
    public var userSessionService: any UserSessionService {
        return self.dependencies.userSessionService
    }
}
