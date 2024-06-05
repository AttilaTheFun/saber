import DependencyFoundation

// @Provider
public protocol UserStorageService: AnyObject {
    var user: User? { get set }
}

// TODO: Generate with @Provider macro.
public protocol UserStorageServiceProvider {
    var userStorageService: UserStorageService { get }
}
