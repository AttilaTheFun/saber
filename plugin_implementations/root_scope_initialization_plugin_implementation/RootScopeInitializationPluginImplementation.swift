import DependencyFoundation
import LoggedOutFeatureInterface
import LoggedInScopeInterface
import LoadingScopeInterface
import ScopeInitializationPluginInterface
import UserServiceInterface
import UserSessionServiceInterface
import WindowServiceInterface
import UIKit

// TODO: Generate with @Injectable macro.
public typealias RootScopeInitializationPluginImplementationDependencies
    = DependencyProvider
    & LoggedInScopeBuilderProvider
    & LoggedOutFeatureBuilderProvider
    & LoadingScopeBuilderProvider
    & UserSessionStorageServiceProvider
    & UserStorageServiceProvider
    & WindowServiceProvider

// @Injectable
public final class RootScopeInitializationPluginImplementation: ScopeInitializationPlugin {

    // @Inject
    private let userSessionStorageService: UserSessionStorageService

    // @Inject
    private let userStorageService: UserStorageService

    // @Inject
    private let windowService: WindowService

    // @Inject
    private let loggedOutFeatureBuilder: any Builder<LoggedOutFeatureArguments, UIViewController>

    // @Inject
    private let loadingScopeBuilder: any Builder<LoadingScopeArguments, AnyObject>

    // @Inject
    private let loggedInScopeBuilder: any Builder<LoggedInScopeArguments, AnyObject>

    // TODO: Generate with @Injectable macro.
    public init(dependencies: RootScopeInitializationPluginImplementationDependencies) {
        self.userSessionStorageService = dependencies.userSessionStorageService
        self.userStorageService = dependencies.userStorageService
        self.windowService = dependencies.windowService
        self.loggedOutFeatureBuilder = dependencies.loggedOutFeatureBuilder
        self.loadingScopeBuilder = dependencies.loadingScopeBuilder
        self.loggedInScopeBuilder = dependencies.loggedInScopeBuilder
    }

    public func execute() {
        guard let userSession = self.userSessionStorageService.userSession else {
            let builder = self.loggedOutFeatureBuilder
            self.windowService.register {
                let arguments = LoggedOutFeatureArguments()
                return builder.build(arguments: arguments)
            }
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
