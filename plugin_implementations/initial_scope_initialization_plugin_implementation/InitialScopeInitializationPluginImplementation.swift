import DependencyFoundation
import LoggedOutScopeInterface
import LoggedInScopeInterface
import LoadingScopeInterface
import UserServiceInterface
import UserSessionServiceInterface
import ScopeInitializationPluginInterface

// TODO: Generate with @Injectable macro.
public typealias InitialScopeInitializationPluginImplementationDependencies
    = DependencyProvider
    & LoggedInScopeBuilderProvider
    & LoggedOutScopeBuilderProvider
    & LoadingScopeBuilderProvider
    & UserSessionStorageServiceProvider
    & UserStorageServiceProvider

// @Injectable
public final class InitialScopeInitializationPluginImplementation: ScopeInitializationPlugin {

    // @Inject
    private let userSessionStorageService: UserSessionStorageService

    // @Inject
    private let userStorageService: UserStorageService

    // @Inject
    private let loggedInScopeBuilder: any Builder<LoggedInScopeArguments, AnyObject>

    // @Inject
    private let loggedOutScopeBuilder: any Builder<LoggedOutScopeArguments, AnyObject>

    // @Inject
    private let loadingScopeBuilder: any Builder<LoadingScopeArguments, AnyObject>

    // TODO: Generate with @Injectable macro.
    public init(dependencies: InitialScopeInitializationPluginImplementationDependencies) {
        self.userSessionStorageService = dependencies.userSessionStorageService
        self.userStorageService = dependencies.userStorageService
        self.loggedInScopeBuilder = dependencies.loggedInScopeBuilder
        self.loggedOutScopeBuilder = dependencies.loggedOutScopeBuilder
        self.loadingScopeBuilder = dependencies.loadingScopeBuilder
    }

    public func execute() {
        guard let userSession = self.userSessionStorageService.userSession else {
            let arguments = LoggedOutScopeArguments()
            self.loggedOutScopeBuilder.build(arguments: arguments)
            return
        }

        guard let user = self.userStorageService.user, user.id == userSession.userID else {
            let arguments = LoadingScopeArguments(userSession: userSession)
            self.loadingScopeBuilder.build(arguments: arguments)
            return
        }

        let arguments = LoggedInScopeArguments(userSession: userSession, user: user)
        self.loggedInScopeBuilder.build(arguments: arguments)
    }
}
