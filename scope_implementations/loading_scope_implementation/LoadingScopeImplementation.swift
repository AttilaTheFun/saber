import DependencyFoundation
import DependencyMacros
import LoadingFeatureInterface
import LoadingFeatureImplementation
import LoggedOutFeatureInterface
import LoggedInFeatureInterface
import UIKit
import UserSessionServiceInterface
import UserServiceInterface
import UserServiceImplementation
import WindowServiceInterface

@ScopeInjectable
public final class LoadingScopeImplementation: Scope, LoadingScopeImplementationChildDependencies {
    @Arguments public let loadingFeature: LoadingFeature
    @Inject public let userStorageService: UserStorageService
    @Inject public let userSessionStorageService: UserSessionStorageService
    @Inject public let windowService: WindowService
    @Inject public let loggedOutFeatureFactory: any Factory<LoggedOutFeature, UIViewController>
    @Inject public let loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController>

    @Store(UserServiceImplementation.self)
    public let userServiceType: UserService.Type

    @Factory(LoadingFeatureViewController.self, arguments: LoadingFeature.self)
    public let loadingFeatureViewControllerType: UIViewController.Type
}
