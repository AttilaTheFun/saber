import DependencyFoundation
import UserSessionServiceInterface
import UserSessionServiceImplementation
import UserServiceInterface
import UserServiceImplementation

public final class RootScope: BaseScope<Void> {}

// TODO: Generate with @Provide macro.
extension RootScope: UserSessionServiceProvider {
    public var userSessionService: any UserSessionService {
        return self.shared {
            UserSessionServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate with @Provide macro.
extension RootScope: UserSessionStorageServiceProvider {
    public var userSessionStorageService: any UserSessionStorageService {
        return self.shared {
            UserSessionStorageServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate with @Provide macro.
extension RootScope: UserStorageServiceProvider {
    public var userStorageService: any UserStorageService {
        return self.shared {
            UserStorageServiceImplementation(dependencies: self)
        }
    }
}
