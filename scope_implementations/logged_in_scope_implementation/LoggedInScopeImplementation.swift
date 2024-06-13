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
final class LoggedInScopeImplementation: BaseScope, LoggedInScopeImplementationChildDependencies {
    @Arguments let loggedInFeature: LoggedInFeature
    @Inject let userStorageService: UserStorageService
    @Inject let userSessionStorageService: UserSessionStorageService
    @Inject let windowService: WindowService
    @Inject let loggedOutFeatureBuilder: any Builder<LoggedOutFeature, UIViewController>

    
    @Initialize(UserSessionServiceImplementation.self)
    let userSessionServiceType: UserSessionService.Type

    // TODO: Generate with @Initialize macros.
    var userSessionService: any UserSessionService {
        return self.strong { [unowned self] in
            return UserSessionServiceImplementation(dependencies: self)
        }
    }

    // @Instantiate(type: UserSessionServiceImplementation.self)
    var loggedInFeatureViewControllerBuilder: any Builder<LoggedInFeature, UIViewController> {
        return self.strong { [unowned self] in
            return LoggedInFeatureViewControllerBuilder(dependencies: self)
        }
    }
}

// TODO: Generate with macro.
extension LoggedInScopeImplementation: LoggedInFeatureViewControllerDependencies {}
