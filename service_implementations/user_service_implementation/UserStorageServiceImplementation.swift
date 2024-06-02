import DependencyFoundation
import Foundation
import UserServiceInterface

private let userKey = "User"

// TODO: Generate with @Injectable macro.
public typealias UserStorageServiceImplementationDependencies
    = DependencyProvider

// @Injectable
public final class UserStorageServiceImplementation: UserStorageService {

    // TODO: Generate with @Injectable macro.
    public init(dependencies: UserStorageServiceImplementationDependencies) {}

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
