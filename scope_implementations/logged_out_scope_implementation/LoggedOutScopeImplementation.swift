import DependencyFoundation
import DependencyMacros
import LoggedOutFeatureInterface
import LoggedOutFeatureImplementation
import LoadingFeatureInterface
import ScopeInitializationPluginInterface
import SwiftFoundation
import UserSessionServiceInterface
import UserSessionServiceImplementation
import UIKit
import WindowServiceInterface

@ScopeViewControllerBuilder(arguments: LoggedOutFeature.self)
@ScopeInjectable
final class LoggedOutScopeImplementation: BaseScope, LoggedOutScopeImplementationChildDependencies {
    @Arguments let loggedOutFeature: LoggedOutFeature
    @Inject let userSessionStorageService: UserSessionStorageService
    @Inject let windowService: WindowService
    @Inject let loadingFeatureBuilder: any Builder<LoadingFeature, UIViewController>

    // TODO: Generate body with @Instantiate macros.
    @Instantiate(UserSessionServiceImplementation.self)
    var userSessionService: any UserSessionService {
        return self.strong { [unowned self] in
            return UserSessionServiceImplementation(dependencies: self)
        }
    }

    // @Instantiate(type: LoggedOutFeatureViewControllerBuilder.self)
    var loggedOutFeatureViewControllerBuilder: any Builder<LoggedOutFeature, UIViewController> {
        return self.strong { [unowned self] in
            return LoggedOutFeatureViewControllerBuilder(dependencies: self)
        }
    }
}

// TODO: Generate with macro.
extension LoggedOutScopeImplementation: LoggedOutFeatureViewControllerDependencies {}
