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
    public lazy var userSessionStorageService: any UserSessionStorageService =
    UserSessionStorageServiceImplementation(dependencies: self)

    @Fulfill(UserStorageServiceImplementationUnownedDependencies.self)
    public lazy var userStorageService: any UserStorageService =
    UserStorageServiceImplementation(dependencies: self)

    @Fulfill(WindowServiceImplementationUnownedDependencies.self)
    public lazy var windowService: any WindowService =
    WindowServiceImplementation(dependencies: self)

    @Fulfill(RootViewControllerInitializationServiceImplementationUnownedDependencies.self)
    public lazy var rootViewControllerInitializationService: any RootViewControllerInitializationService =
    RootViewControllerInitializationServiceImplementation(dependencies: self)

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
