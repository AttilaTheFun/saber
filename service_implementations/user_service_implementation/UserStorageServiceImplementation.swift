import DependencyFoundation
import Foundation
import KeyFoundation
import KeyValueServiceInterface
import UserServiceInterface

// TODO: Generate with @Injectable macro.
public typealias UserStorageServiceImplementationDependencies
    = DependencyProvider
    & KeyValueServiceProvider

// @Injectable
public final class UserStorageServiceImplementation: UserStorageService {

    // @Inject
    let keyValueService: KeyValueService

    // TODO: Generate with @Injectable macro.
    public init(dependencies: UserStorageServiceImplementationDependencies) {
        self.keyValueService = dependencies.keyValueService
    }

    public var user: User? {
        get {
            return self.keyValueService.get(key: .user)
        }
        set {
            if let newValue {
                self.keyValueService.set(value: newValue, for: .user)
            } else {
                self.keyValueService.removeValue(for: .user)
            }
        }
    }
}

extension User {
    static var namespace: Namespace {
        Namespace(type: User.self)
    }
}

extension Name {
    static let user = Name(name: "User", namespace: User.namespace)
}

extension StorageKey {
    static var user: StorageKey<User> {
        StorageKey<User>(name: .user)
    }
}
