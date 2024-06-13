import DependencyMacros

public protocol UserSessionStorageService: AnyObject {
    var userSession: UserSession? { get set }
}
