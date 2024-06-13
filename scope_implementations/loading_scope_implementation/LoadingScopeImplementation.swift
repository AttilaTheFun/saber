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
final class LoadingScopeImplementation: BaseScope {
    @Arguments let loadingFeature: LoadingFeature
    @Inject let userStorageService: UserStorageService
    @Inject let userSessionStorageService: UserSessionStorageService
    @Inject let windowService: WindowService
    @Inject let loggedOutFeatureBuilder: any Builder<LoggedOutFeature, UIViewController>
    @Inject let loggedInFeatureBuilder: any Builder<LoggedInFeature, UIViewController>

    // @Instantiate(type: UserServiceImplementation.self)
    // let userService: UserService

    // @Instantiate(type: LoadingFeatureViewControllerBuilder.self)
    // let loadingFeatureViewControllerBuilder: any Builder<LoadingFeature, UIViewController>
}

// TODO: Generate with macro.
extension LoadingScopeImplementation: LoadingFeatureProvider {}

// TODO: Generate with macro.
extension LoadingScopeImplementation: LoadingFeatureViewControllerDependencies {}
extension LoadingScopeImplementation: UserServiceImplementationDependencies {}

// TODO: Generate with @Instantiate macros.
extension LoadingScopeImplementation {
    var userService: any UserService {
        return self.strong { [unowned self] in
            return UserServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate with @Instantiate macro.
extension LoadingScopeImplementation {
    var loadingFeatureViewControllerBuilder: any Builder<LoadingFeature, UIViewController> {
        return self.strong { [unowned self] in
            return LoadingFeatureViewControllerBuilder(dependencies: self)
        }
    }
}
