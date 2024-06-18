import DependencyFoundation
import DependencyMacros
import LoggedInFeatureInterface
import LoggedInFeatureInterface
import LoggedInFeatureImplementation
import LoggedOutFeatureInterface
import UIKit
import UserServiceInterface
import UserSessionServiceInterface
import UserSessionServiceImplementation
import WindowServiceInterface

@Injectable
public final class LoggedInScope {
    @Arguments public var loggedInArguments: LoggedInArguments
    @Inject public var userStorageService: any UserStorageService
    @Inject public var userSessionStorageService: any UserSessionStorageService
    @Inject public var windowService: any WindowService
    @Inject public var loggedOutViewControllerFactory: any Factory<LoggedOutArguments, UIViewController>

    @Store(UserSessionServiceImplementation.self)
    public var userSessionService: any UserSessionService

    @Factory(LoggedInViewController.self)
    public var loggedInViewControllerFactory: any Factory<LoggedInArguments, UIViewController>
}
