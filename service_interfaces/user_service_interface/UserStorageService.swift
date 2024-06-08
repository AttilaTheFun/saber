import DependencyFoundation

@Provider
@MainActor
public protocol UserStorageService: AnyObject {
    var user: User? { get set }
}
