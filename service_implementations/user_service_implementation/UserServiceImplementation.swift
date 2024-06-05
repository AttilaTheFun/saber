import DependencyFoundation
import Foundation
import UserServiceInterface
import LoadingFeatureInterface

private let userIDsToUsersKey = "UserIDsToUsers"

// TODO: Generate with @Injectable macro.
public typealias UserServiceImplementationDependencies
    = DependencyProvider
    & LoadingFeatureArgumentsProvider

// @Injectable
public final class UserServiceImplementation: UserService {

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

    // @Inject
    private let loadingFeatureArguments: LoadingFeatureArguments

    // TODO: Generate with @Injectable macro.
    public init(dependencies: UserServiceImplementationDependencies) {
        self.loadingFeatureArguments = dependencies.loadingFeatureArguments
    }

    private enum UserServiceImplementationError: Error {
        case missingUser
    }

    public func getCurrentUser() async throws -> User {
        guard let user = self.userIDsToUsers[self.loadingFeatureArguments.userSession.userID] else {
            throw UserServiceImplementationError.missingUser
        }

        return user
    }
}
