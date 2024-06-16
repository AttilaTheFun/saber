import DependencyFoundation
import DependencyMacros
import LoggedOutFeatureInterface
import LoggedOutScopeImplementation
import LoadingFeatureInterface
import LoadingScopeImplementation
import LoggedInFeatureInterface
import LoggedInScopeImplementation
import RootFeatureInterface
import RootViewControllerInitializationServiceImplementation
import UserSessionServiceInterface
import UserSessionServiceImplementation
import UserServiceInterface
import UserServiceImplementation
import UIKit
import WindowServiceInterface
import WindowServiceImplementation

@Injectable
public final class RootScopeImplementation {
    @Arguments public var rootFeature: RootFeature

    @Store(UserSessionStorageServiceImplementation.self)
    public var userSessionStorageService: any UserSessionStorageService

    @Store(UserStorageServiceImplementation.self)
    public var userStorageService: any UserStorageService

    @Store(WindowServiceImplementation.self)
    public var windowService: any WindowService

    @Store(RootViewControllerInitializationServiceImplementation.self)
    public var rootViewControllerInitializationService: any RootViewControllerInitializationService

    @Factory(LoggedOutScopeImplementation.self, factory: \.loggedOutFeatureViewControllerFactory)
    public var loggedOutFeatureFactory: any Factory<LoggedOutFeature, UIViewController>

    @Factory(LoadingScopeImplementation.self, factory: \.loadingFeatureViewControllerFactory)
    public var loadingFeatureFactory: any Factory<LoadingFeature, UIViewController>

    @Factory(LoggedInScopeImplementation.self, factory: \.loggedInFeatureViewControllerFactory)
    public var loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController>
}
