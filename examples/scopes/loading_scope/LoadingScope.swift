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
@Scope
public final class LoadingScope {
    @Argument public var userSession: UserSession
    @Inject public var userStorageService: any UserStorageService
    @Inject public var userSessionStorageService: any UserSessionStorageService
    @Inject public var windowService: any WindowService
    @Inject public var loggedOutViewControllerFactory: Factory<LoggedOutScopeArguments, UIViewController>
    @Inject public var loggedInTabBarControllerFactory: Factory<LoggedInScopeArguments, UIViewController>

    @Fulfill(UserServiceImplementationUnownedDependencies.self)
    lazy var userService: any UserService = UserServiceImplementation(dependencies: self.fulfilledDependencies)

    @Fulfill(LoadingViewControllerDependencies.self)
    public lazy var rootFactory: Factory<Void, UIViewController> = Factory { [unowned self] in
        LoadingViewController(dependencies: self.fulfilledDependencies)
    }
}
