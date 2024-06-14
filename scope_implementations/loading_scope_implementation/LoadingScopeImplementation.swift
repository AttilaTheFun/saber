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

@Injectable
public final class LoadingScopeImplementation: LoadingScopeImplementationChildDependencies {
    @Arguments public let loadingFeature: LoadingFeature
    @Inject public let userStorageService: any UserStorageService
    @Inject public let userSessionStorageService: any UserSessionStorageService
    @Inject public let windowService: any WindowService
    @Inject public let loggedOutFeatureFactory: any Factory<LoggedOutFeature, UIViewController>
    @Inject public let loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController>

    @Store(UserServiceImplementation.self)
    public var userService: any UserService

    @Factory(LoadingFeatureViewController.self)
    public var loadingFeatureViewControllerFactory: any Factory<LoadingFeature, UIViewController>
}
