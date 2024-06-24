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

@Injectable
@Scope
public final class RootScope {
    @Argument public var endpointURL: URL

    @Store(UserSessionStorageServiceImplementation.self)
    public var userSessionStorageService: any UserSessionStorageService

    @Store(UserStorageServiceImplementation.self)
    public var userStorageService: any UserStorageService

    @Store(WindowServiceImplementation.self)
    public var windowService: any WindowService

    @Store(RootViewControllerInitializationServiceImplementation.self)
    public var rootViewControllerInitializationService: any RootViewControllerInitializationService

    @Factory(LoggedOutScope.self, factory: \.rootFactory)
    public var loggedOutViewControllerFactory: Factory<LoggedOutScopeArguments, UIViewController>

    @Factory(LoadingScope.self, factory: \.rootFactory)
    public var loadingViewControllerFactory: Factory<LoadingScopeArguments, UIViewController>

    @Factory(LoggedInScope.self, factory: \.rootFactory)
    public var loggedInTabBarControllerFactory: Factory<LoggedInScopeArguments, UIViewController>
}

extension RootScope: RootScopeFulfilledDependencies {}
