import DependencyMacros
import Foundation
import UserServiceInterface
import LoadingFeatureInterface

private let userIDsToUsersKey = "UserIDsToUsers"

@Injectable
public final class UserServiceImplementation: UserService {
    @Inject private var loadingFeature: LoadingFeature

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

    private enum UserServiceImplementationError: Error {
        case missingUser
    }

    public func getCurrentUser() async throws -> User {
        guard let user = self.userIDsToUsers[self.loadingFeature.userSession.userID] else {
            throw UserServiceImplementationError.missingUser
        }

        return user
    }
}
