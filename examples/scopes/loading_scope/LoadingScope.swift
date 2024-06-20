import Saber
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
public final class LoadingScope: Scope {
    @Argument public var userSession: UserSession
    @Inject public var userStorageService: any UserStorageService
    @Inject public var userSessionStorageService: any UserSessionStorageService
    @Inject public var windowService: any WindowService
    @Inject public var loggedOutViewControllerFactory: any Factory<LoggedOutViewControllerArguments, UIViewController>
    @Inject public var loggedInTabBarControllerFactory: any Factory<LoggedInTabBarControllerArguments, UIViewController>

    @Store(UserServiceImplementation.self)
    public var userService: any UserService

    @Factory(LoadingViewController.self)
    public var rootFactory: any Factory<LoadingViewControllerArguments, UIViewController>
}