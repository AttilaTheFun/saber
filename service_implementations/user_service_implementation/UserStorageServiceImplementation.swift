import DependencyMacros
import Foundation
import UserServiceInterface

private let userKey = "User"

@Injectable(.unowned)
public final class UserStorageServiceImplementation: UserStorageService {
    public var user: User? {
        get {
            if
                let data = UserDefaults.standard.data(forKey: userKey),
                let user = try? JSONDecoder().decode(User.self, from: data)
            {
                return user
            }

            return nil
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: userKey)
            }
        }
    }
}
