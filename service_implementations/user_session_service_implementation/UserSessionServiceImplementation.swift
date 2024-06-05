import DependencyFoundation
import Foundation
import KeyFoundation
import KeyValueServiceInterface
import UserServiceInterface
import UserSessionServiceInterface

// TODO: Generate with @Injectable macro.
public typealias UserSessionServiceImplementationDependencies
    = DependencyProvider
    & KeyValueServiceProvider

// @Injectable
public final class UserSessionServiceImplementation: UserSessionService {

    // @Inject
    let keyValueService: KeyValueService

    // TODO: Generate with @Injectable macro.
    public init(dependencies: UserSessionServiceImplementationDependencies) {
        self.keyValueService = dependencies.keyValueService
    }

    // MARK: UserSessionService

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

    // MARK: Private

    private var userSessionIDsToUserSessions: [UUID : UserSession] {
        get {
            return self.keyValueService.get(key: .userSessionIDsToUserSessionsKey) ?? [:]
        }
        set {
            self.keyValueService.set(value: newValue, for: .userSessionIDsToUserSessionsKey)
        }
    }

    private var userIDsToUsers: [UUID : User] {
        get {
            return self.keyValueService.get(key: .userIDsToUsersKey) ?? [:]
        }
        set {
            self.keyValueService.set(value: newValue, for: .userIDsToUsersKey)
        }
    }

    private var usernamesToUsers: [String : User] {
        get {
            return self.keyValueService.get(key: .usernamesToUsersKey) ?? [:]
        }
        set {
            self.keyValueService.set(value: newValue, for: .usernamesToUsersKey)
        }
    }
}

extension User {
    static var namespace: Namespace {
        Namespace(type: User.self)
    }
}

extension Name {
    static let userSessionIDsToUserSessions = Name(name: "UserSessionIDsToUserSessions", namespace: UserSession.namespace)
    static let userIDsToUsers = Name(name: "UserIDsToUsers", namespace: User.namespace)
    static let usernamesToUsers = Name(name: "UsernamesToUsers", namespace: User.namespace)
}

extension StorageKey {
    static var userSessionIDsToUserSessionsKey: StorageKey<[UUID : UserSession]> {
        StorageKey<[UUID : UserSession]>(name: .userSessionIDsToUserSessions)
    }

    static var userIDsToUsersKey: StorageKey<[UUID : User]> {
        StorageKey<[UUID : User]>(name: .userIDsToUsers)
    }

    static var usernamesToUsersKey: StorageKey<[String : User]> {
        StorageKey<[String : User]>(name: .usernamesToUsers)
    }
}
