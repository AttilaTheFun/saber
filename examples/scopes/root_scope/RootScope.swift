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

    @Fulfill(UserSessionStorageServiceImplementationUnownedDependencies.self)
    @Store(UserSessionStorageServiceImplementation.self)
    public var userSessionStorageService: any UserSessionStorageService

    @Fulfill(UserStorageServiceImplementationUnownedDependencies.self)
    @Store(UserStorageServiceImplementation.self)
    public var userStorageService: any UserStorageService

    @Fulfill(WindowServiceImplementationUnownedDependencies.self)
    @Store(WindowServiceImplementation.self)
    public var windowService: any WindowService

    @Fulfill(RootViewControllerInitializationServiceImplementationUnownedDependencies.self)
    @Store(RootViewControllerInitializationServiceImplementation.self)
    public var rootViewControllerInitializationService: any RootViewControllerInitializationService

    @Fulfill(LoggedOutScopeDependencies.self)
    @Factory(LoggedOutScope.self, factory: \.rootFactory)
    public var loggedOutViewControllerFactory: Factory<LoggedOutScopeArguments, UIViewController>

    @Fulfill(LoadingScopeDependencies.self)
    @Factory(LoadingScope.self, factory: \.rootFactory)
    public var loadingViewControllerFactory: Factory<LoadingScopeArguments, UIViewController>

    @Fulfill(LoggedInScopeDependencies.self)
    @Factory(LoggedInScope.self, factory: \.rootFactory)
    public var loggedInTabBarControllerFactory: Factory<LoggedInScopeArguments, UIViewController>
}

extension RootScope: RootScopeFulfilledDependencies {}
