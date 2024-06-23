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
@Scope(fulfilledDependencies: .strong)
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
    public lazy var loggedOutViewControllerFactory: Factory<LoggedOutScopeArguments, UIViewController> =
    Factory { [unowned self] arguments in
        let scope = LoggedOutScope(arguments: arguments, dependencies: self)
        return scope.rootFactory.build()
    }

    @Fulfill(LoadingScopeDependencies.self)
    public lazy var loadingViewControllerFactory: Factory<LoadingScopeArguments, UIViewController> =
    Factory { [unowned self] arguments in
        let scope = LoadingScope(arguments: arguments, dependencies: self)
        return scope.rootFactory.build()
    }

    @Fulfill(LoggedInScopeDependencies.self)
    public lazy var loggedInTabBarControllerFactory: Factory<LoggedInScopeArguments, UIViewController> =
    Factory { [unowned self] arguments in
        let scope = LoggedInScope(arguments: arguments, dependencies: self)
        return scope.rootFactory.build()
    }
}

extension RootScope: RootScopeFulfilledDependencies {}
