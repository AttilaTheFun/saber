import DependencyFoundation

// @ServiceProvider
public protocol UserStorageService {
    var user: User? { get set }
}

// TODO: Generate with @ServiceProvider macro.
public protocol UserStorageServiceProvider {
    var userStorageService: UserStorageService { get }
}
