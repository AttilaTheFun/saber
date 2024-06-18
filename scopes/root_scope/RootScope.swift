import DependencyFoundation
import DependencyMacros
import LoggedOutFeatureInterface
import LoggedOutScope
import LoadingFeatureInterface
import LoadingScope
import LoggedInFeatureInterface
import LoggedInScope
import RootFeatureInterface
import RootViewControllerInitializationServiceImplementation
import UserSessionServiceInterface
import UserSessionServiceImplementation
import UserServiceInterface
import UserServiceImplementation
import UIKit
import WindowServiceInterface
import WindowServiceImplementation

@Injectable(.root)
public final class RootScope {
    @Arguments public var rootArguments: RootArguments

    @Store(UserSessionStorageServiceImplementation.self)
    public var userSessionStorageService: any UserSessionStorageService

    @Store(UserStorageServiceImplementation.self)
    public var userStorageService: any UserStorageService

    @Store(WindowServiceImplementation.self)
    public var windowService: any WindowService

    @Store(RootViewControllerInitializationServiceImplementation.self)
    public var rootViewControllerInitializationService: any RootViewControllerInitializationService

    @Factory(LoggedOutScope.self, factory: \.loggedOutViewControllerFactory)
    public var loggedOutViewControllerFactory: any Factory<LoggedOutArguments, UIViewController>

    @Factory(LoadingScope.self, factory: \.loadingViewControllerFactory)
    public var loadingViewControllerFactory: any Factory<LoadingArguments, UIViewController>

    @Factory(LoggedInScope.self, factory: \.loggedInTabBarControllerFactory)
    public var loggedInTabBarControllerFactory: any Factory<LoggedInArguments, UIViewController>
}
