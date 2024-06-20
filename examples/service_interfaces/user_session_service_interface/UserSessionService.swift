import Foundation

public protocol UserSessionService: AnyObject {
    func createSession(username: String, password: String) async throws -> UserSession
    func deleteSession(id: UUID) async throws
}
