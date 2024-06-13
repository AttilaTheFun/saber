import DependencyFoundation
import DependencyMacros
import LoggedInFeatureInterface
import LoggedInFeatureInterface
import LoggedInFeatureImplementation
import LoggedOutFeatureInterface
import ScopeInitializationPluginInterface
import UIKit
import UserServiceInterface
import UserSessionServiceInterface
import UserSessionServiceImplementation
import WindowServiceInterface

@ScopeViewControllerBuilder(arguments: LoggedInFeature.self)
@ScopeInjectable
final class LoggedInScopeImplementation: BaseScope {
    @Arguments let loggedInFeature: LoggedInFeature
    @Inject let userStorageService: UserStorageService
    @Inject let userSessionStorageService: UserSessionStorageService
    @Inject let windowService: WindowService
    @Inject let loggedOutFeatureBuilder: any Builder<LoggedOutFeature, UIViewController>

    // @Provide(type: UserSessionServiceProvider.self)
    // @Instantiate(type: UserSessionServiceImplementation.self)
    // let userSessionService: UserSessionService
}

// TODO: Generate with macro.
extension LoggedInScopeImplementation: UserSessionServiceImplementationDependencies {}
extension LoggedInScopeImplementation: LoggedInFeatureViewControllerDependencies {}

// TODO: Generate with @Instantiate macro.
extension LoggedInScopeImplementation {
    var userSessionService: any UserSessionService {
        return self.strong { [unowned self] in
            return UserSessionServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate with @Instantiate macro.
extension LoggedInScopeImplementation {
    var loggedInFeatureViewControllerBuilder: any Builder<LoggedInFeature, UIViewController> {
        return self.strong { [unowned self] in
            return LoggedInFeatureViewControllerBuilder(dependencies: self)
        }
    }
}
