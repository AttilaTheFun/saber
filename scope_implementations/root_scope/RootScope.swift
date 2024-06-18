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
    @Arguments public var rootFeature: RootFeature

    @Store(UserSessionStorageServiceImplementation.self)
    public var userSessionStorageService: any UserSessionStorageService

    @Store(UserStorageServiceImplementation.self)
    public var userStorageService: any UserStorageService

    @Store(WindowServiceImplementation.self)
    public var windowService: any WindowService

    @Store(RootViewControllerInitializationServiceImplementation.self)
    public var rootViewControllerInitializationService: any RootViewControllerInitializationService

    @Factory(LoggedOutScope.self, factory: \.loggedOutFeatureViewControllerFactory)
    public var loggedOutFeatureFactory: any Factory<LoggedOutFeature, UIViewController>

    @Factory(LoadingScope.self, factory: \.loadingFeatureViewControllerFactory)
    public var loadingFeatureFactory: any Factory<LoadingFeature, UIViewController>

    @Factory(LoggedInScope.self, factory: \.loggedInFeatureViewControllerFactory)
    public var loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController>
}
