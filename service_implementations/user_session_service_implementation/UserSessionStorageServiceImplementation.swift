import DependencyFoundation
import Foundation
import KeyFoundation
import KeyValueServiceInterface
import UserSessionServiceInterface

// TODO: Generate with @Injectable macro.
public typealias UserSessionStorageServiceImplementationDependencies
    = DependencyProvider
    & KeyValueServiceProvider

// @Injectable
public final class UserSessionStorageServiceImplementation: UserSessionStorageService {

    // @Inject
    let keyValueService: KeyValueService

    // TODO: Generate with @Injectable macro.
    public init(dependencies: UserSessionStorageServiceImplementationDependencies) {
        self.keyValueService = dependencies.keyValueService
    }

    public var userSession: UserSession? {
        get {
            return self.keyValueService.get(key: .userSession)
        }
        set {
            if let newValue {
                self.keyValueService.set(value: newValue, for: .userSession)
            } else {
                self.keyValueService.removeValue(for: .userSession)
            }
        }
    }
}

extension UserSession {
    static var namespace: Namespace {
        Namespace(type: UserSession.self)
    }
}

extension Name {
    static let userSession = Name(name: "UserSession", namespace: UserSession.namespace)
}

extension StorageKey {
    static var userSession: StorageKey<UserSession> {
        StorageKey<UserSession>(name: .userSession)
    }
}
