import DependencyFoundation
import LoggedOutFeatureInterface
import LoggedInFeatureInterface
import LoadingFeatureInterface
import ScopeInitializationPluginInterface
import UserServiceInterface
import UserSessionServiceInterface
import WindowServiceInterface
import UIKit

// TODO: Generate with @Injectable macro.
public typealias RootScopeInitializationPluginImplementationDependencies
    = DependencyProvider
    & LoggedOutFeatureBuilderProvider
    & LoadingFeatureBuilderProvider
    & LoggedInFeatureBuilderProvider
    & UserSessionStorageServiceProvider
    & UserStorageServiceProvider
    & WindowServiceProvider

// @Injectable
@MainActor
public final class RootScopeInitializationPluginImplementation: ScopeInitializationPlugin {

    // @Inject
    private let userSessionStorageService: UserSessionStorageService

    // @Inject
    private let userStorageService: UserStorageService

    // @Inject
    private let windowService: WindowService

    // @Inject
    private let loggedOutFeatureBuilder: any Builder<LoggedOutFeature, UIViewController>

    // @Inject
    private let loadingFeatureBuilder: any Builder<LoadingFeature, UIViewController>

    // @Inject
    private let loggedInFeatureBuilder: any Builder<LoggedInFeature, UIViewController>

    // TODO: Generate with @Injectable macro.
    public init(dependencies: RootScopeInitializationPluginImplementationDependencies) {
        self.userSessionStorageService = dependencies.userSessionStorageService
        self.userStorageService = dependencies.userStorageService
        self.windowService = dependencies.windowService
        self.loggedOutFeatureBuilder = dependencies.loggedOutFeatureBuilder
        self.loadingFeatureBuilder = dependencies.loadingFeatureBuilder
        self.loggedInFeatureBuilder = dependencies.loggedInFeatureBuilder
    }

    public func execute() {
        guard let userSession = self.userSessionStorageService.userSession else {
            self.userSessionStorageService.userSession = nil
            self.userStorageService.user = nil
            let builder = self.loggedOutFeatureBuilder
            self.windowService.register {
                let arguments = LoggedOutFeature()
                return builder.build(arguments: arguments)
            }
            return
        }

        guard let user = self.userStorageService.user, user.id == userSession.userID else {
            self.userStorageService.user = nil
            let builder = self.loadingFeatureBuilder
            self.windowService.register {
                let arguments = LoadingFeature(userSession: userSession)
                return builder.build(arguments: arguments)
            }
            return
        }

        let builder = self.loggedInFeatureBuilder
        self.windowService.register {
            let arguments = LoggedInFeature(userSession: userSession, user: user)
            return builder.build(arguments: arguments)
        }
    }
}
