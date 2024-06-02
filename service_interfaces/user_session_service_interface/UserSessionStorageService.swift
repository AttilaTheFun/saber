import DependencyFoundation

// @ServiceProvider
public protocol UserSessionStorageService {
    var userSession: UserSession? { get set }
}

// TODO: Generate with @ServiceProvider macro.
public protocol UserSessionStorageServiceProvider {
    var userSessionStorageService: UserSessionStorageService { get }
}

// TODO: Generate with @ServiceProvider macro with ability to opt out of automatic propagation.
extension DependencyContainer: UserSessionStorageServiceProvider where Dependencies: UserSessionStorageServiceProvider {
    public var userSessionStorageService: any UserSessionStorageService {
        return self.dependencies.userSessionStorageService
    }
}
