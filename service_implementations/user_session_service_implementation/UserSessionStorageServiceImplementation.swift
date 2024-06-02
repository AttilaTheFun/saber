import DependencyFoundation
import Foundation
import UserSessionServiceInterface

private let userSessionKey = "UserSession"

// TODO: Generate with @Injectable macro.
public typealias UserSessionStorageServiceImplementationDependencies
    = DependencyProvider

// @Injectable
public final class UserSessionStorageServiceImplementation: UserSessionStorageService {

    // TODO: Generate with @Injectable macro.
    public init(dependencies: UserSessionStorageServiceImplementationDependencies) {}

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
