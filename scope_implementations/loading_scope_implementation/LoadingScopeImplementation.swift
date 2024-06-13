import DependencyFoundation
import DependencyMacros
import LoadingFeatureInterface
import LoadingFeatureImplementation
import LoggedOutFeatureInterface
import LoggedInFeatureInterface
import ScopeInitializationPluginInterface
import UIKit
import UserSessionServiceInterface
import UserServiceInterface
import UserServiceImplementation
import WindowServiceInterface

@ScopeViewControllerBuilder(arguments: LoadingFeature.self)
@ScopeInjectable
final class LoadingScopeImplementation: BaseScope, LoadingScopeImplementationChildDependencies {
    @Arguments let loadingFeature: LoadingFeature
    @Inject let userStorageService: UserStorageService
    @Inject let userSessionStorageService: UserSessionStorageService
    @Inject let windowService: WindowService
    @Inject let loggedOutFeatureBuilder: any Builder<LoggedOutFeature, UIViewController>
    @Inject let loggedInFeatureBuilder: any Builder<LoggedInFeature, UIViewController>

    // TODO: Generate body with @Instantiate macros.
    @Initialize(UserServiceImplementation.self)
    let userServiceType: UserService.Type

    var userService: any UserService {
        return self.strong { [unowned self] in
            return UserServiceImplementation(dependencies: self)
        }
    }

//    @Instantiate(LoadingFeatureViewControllerBuilder.self)
    var loadingFeatureViewControllerBuilder: any Builder<LoadingFeature, UIViewController> {
        return self.strong { [unowned self] in
            return LoadingFeatureViewControllerBuilder(dependencies: self)
        }
    }
}

// TODO: Generate with macro.
extension LoadingScopeImplementation: LoadingFeatureViewControllerDependencies {}
