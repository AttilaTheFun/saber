import DependencyFoundation

// @Provider
@MainActor
public protocol UserSessionStorageService: AnyObject {
    var userSession: UserSession? { get set }
}

// TODO: Generate with @Provider macro.
public protocol UserSessionStorageServiceProvider {
    var userSessionStorageService: UserSessionStorageService { get }
}
