import DependencyMacros

public protocol UserStorageService: AnyObject {
    var user: User? { get set }
}
