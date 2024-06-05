import DependencyFoundation
import KeyFoundation
import KeyValueServiceInterface
import Foundation
import UserServiceInterface
import LoadingFeatureInterface

// TODO: Generate with @Injectable macro.
public typealias UserServiceImplementationDependencies
    = DependencyProvider
    & KeyValueServiceProvider
    & LoadingFeatureArgumentsProvider

// @Injectable
public final class UserServiceImplementation: UserService {

    // @Inject
    let keyValueService: KeyValueService

    // @Inject
    private let loadingFeatureArguments: LoadingFeatureArguments

    // TODO: Generate with @Injectable macro.
    public init(dependencies: UserServiceImplementationDependencies) {
        self.keyValueService = dependencies.keyValueService
        self.loadingFeatureArguments = dependencies.loadingFeatureArguments
    }

    // MARK: UserService

    private enum UserServiceImplementationError: Error {
        case missingUser
    }

    public func getCurrentUser() async throws -> User {
        guard let user = self.userIDsToUsers[self.loadingFeatureArguments.userSession.userID] else {
            throw UserServiceImplementationError.missingUser
        }

        return user
    }

    // MARK: Private

    private var userIDsToUsers: [UUID : User] {
        get {
            return self.keyValueService.get(key: .userIDsToUsersKey) ?? [:]
        }
        set {
            self.keyValueService.set(value: newValue, for: .userIDsToUsersKey)
        }
    }
}

extension Name {
    static let userIDsToUsers = Name(name: "UserIDsToUsers", namespace: User.namespace)
}

extension StorageKey {
    static var userIDsToUsersKey: StorageKey<[UUID : User]> {
        StorageKey<[UUID : User]>(name: .userIDsToUsers)
    }
}

