import DependencyMacros
import Foundation
import UserSessionServiceInterface

private let userSessionKey = "UserSession"

@Injectable(.unowned)
public final class UserSessionStorageServiceImplementation: UserSessionStorageService {
    public var userSession: UserSession? {
        get {
            if 
                let data = UserDefaults.standard.data(forKey: userSessionKey),
                let user = try? JSONDecoder().decode(UserSession.self, from: data)
            {
                return user
            }

            return nil
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: userSessionKey)
            }
        }
    }
}
