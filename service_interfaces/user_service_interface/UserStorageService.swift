
// @ServiceProvider
public protocol UserStorageService {
    var user: User? { get set }
}

// TODO: Generate with @ServiceProvider macro.
public protocol UserStorageServiceProvider {
    var userStorageService: UserStorageService { get }
}

// TODO: Generate with @ServiceProvider macro with ability to opt out of automatic propagation.
extension DependencyContainer: UserStorageServiceProvider where Dependencies: UserStorageServiceProvider {
    public var userStorageService: any UserStorageService {
        return self.dependencies.userStorageService
    }
}