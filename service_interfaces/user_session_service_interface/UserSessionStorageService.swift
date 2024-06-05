import DependencyFoundation

// @ServiceProvider
public protocol UserSessionStorageService: AnyObject {
    var userSession: UserSession? { get set }
}

// TODO: Generate with @ServiceProvider macro.
public protocol UserSessionStorageServiceProvider {
    var userSessionStorageService: UserSessionStorageService { get }
}
