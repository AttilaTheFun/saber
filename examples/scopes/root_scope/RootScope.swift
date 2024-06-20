import Saber
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

@Injectable(childDependencies: .strong)
public final class RootScope {
    public typealias Arguments = RootArguments

    @Store(UserSessionStorageServiceImplementation.self)
    public var userSessionStorageService: any UserSessionStorageService

    @Store(UserStorageServiceImplementation.self)
    public var userStorageService: any UserStorageService

    @Store(WindowServiceImplementation.self)
    public var windowService: any WindowService

    @Store(RootViewControllerInitializationServiceImplementation.self)
    public var rootViewControllerInitializationService: any RootViewControllerInitializationService

    @Factory(LoggedOutScope.self, factory: \.rootFactory)
    public var loggedOutViewControllerFactory: any Factory<LoggedOutViewControllerArguments, UIViewController>

    @Factory(LoadingScope.self, factory: \.rootFactory)
    public var loadingViewControllerFactory: any Factory<LoadingViewControllerArguments, UIViewController>

    @Factory(LoggedInScope.self, factory: \.rootFactory)
    public var loggedInTabBarControllerFactory: any Factory<LoggedInTabBarControllerArguments, UIViewController>

    @Argument public var endpointURL: URL
}
