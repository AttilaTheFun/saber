import DependencyMacros
import Foundation
import UserServiceInterface
import UserSessionServiceInterface

private let userSessionIDsToUserSessionsKey = "UserSessionIDsToUserSessions"
private let userIDsToUsersKey = "UserIDsToUsers"
private let usernamesToUsersKey = "UsernamesToUsers"

@Injectable(dependencies: .unowned)
public final class UserSessionServiceImplementation: UserSessionService {
    private var userSessionIDsToUserSessions: [UUID : UserSession] {
        get {
            if
                let data = UserDefaults.standard.data(forKey: userSessionIDsToUserSessionsKey),
                let user = try? JSONDecoder().decode([UUID : UserSession].self, from: data)
            {
                return user
            }

            return [:]
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: userSessionIDsToUserSessionsKey)
            }
        }
    }

    private var userIDsToUsers: [UUID : User] {
        get {
            if
                let data = UserDefaults.standard.data(forKey: userIDsToUsersKey),
                let user = try? JSONDecoder().decode([UUID : User].self, from: data)
            {
                return user
            }

            return [:]
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: userIDsToUsersKey)
            }
        }
    }

    private var usernamesToUsers: [String : User] {
        get {
            if
                let data = UserDefaults.standard.data(forKey: usernamesToUsersKey),
                let user = try? JSONDecoder().decode([String : User].self, from: data)
            {
                return user
            }

            return [:]
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: usernamesToUsersKey)
            }
        }
    }

    public func createSession(username: String, password: String) async throws -> UserSession {
        let user = self.usernamesToUsers[username] ?? User(id: UUID(), username: username)
        self.usernamesToUsers[username] = user
        self.userIDsToUsers[user.id] = user
        let userSession = UserSession(id: UUID(), userID: user.id, token: "token")
        self.userSessionIDsToUserSessions[userSession.id] = userSession
        return userSession
    }

    public func deleteSession(id: UUID) async throws {
        self.userSessionIDsToUserSessions[id] = nil
    }
}

