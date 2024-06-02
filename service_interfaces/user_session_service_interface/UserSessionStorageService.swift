import DependencyFoundation

// @ServiceProvider
public protocol UserSessionStorageService {
    var userSession: UserSession? { get set }
}

// TODO: Generate with @ServiceProvider macro.
public protocol UserSessionStorageServiceProvider {
    var userSessionStorageService: UserSessionStorageService { get }
}
