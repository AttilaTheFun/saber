import DependencyMacrosFoundation

@Provider
@MainActor
public protocol UserSessionStorageService: AnyObject {
    var userSession: UserSession? { get set }
}
