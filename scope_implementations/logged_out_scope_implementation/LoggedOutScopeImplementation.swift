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
final class LoggedOutScopeImplementation: BaseScope {
    @Arguments let loggedOutFeature: LoggedOutFeature
    @Inject let userSessionStorageService: UserSessionStorageService
    @Inject let windowService: WindowService
    @Inject let loadingFeatureBuilder: any Builder<LoadingFeature, UIViewController>

    // @Provide(type: UserSessionServiceProvider.self)
    // @Instantiate(type: UserSessionServiceImplementation.self)
    // let userSessionService: UserSessionService

    // @Instantiate(type: LoggedOutFeatureViewControllerBuilder.self)
    // let loggedOutFeatureViewControllerBuilder: any Builder<LoggedOutFeature, UIViewController>
}

// TODO: Generate with macro.
extension LoggedOutScopeImplementation: UserSessionServiceImplementationDependencies {}
extension LoggedOutScopeImplementation: LoggedOutFeatureViewControllerDependencies {}

// TODO: Generate from @Instantiate macros.
extension LoggedOutScopeImplementation {
    var userSessionService: any UserSessionService {
        return self.strong { [unowned self] in
            return UserSessionServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from the @Instantiate macro.
extension LoggedOutScopeImplementation {
    var loggedOutFeatureViewControllerBuilder: any Builder<LoggedOutFeature, UIViewController> {
        return self.strong { [unowned self] in
            return LoggedOutFeatureViewControllerBuilder(dependencies: self)
        }
    }
}
