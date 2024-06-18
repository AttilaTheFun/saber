import DependencyFoundation
import DependencyMacros
import LoggedInFeatureInterface
import LoggedInFeatureImplementation
import LoggedOutFeatureInterface
import InboxFeatureInterface
import InboxScope
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

    // TODO: Turn into ProfileViewController and extract into separate module.
    @Factory(LoggedInViewController.self)
    public var loggedInViewControllerFactory: any Factory<LoggedInArguments, UIViewController>

    @Factory(LoggedInTabBarController.self)
    public var loggedInTabBarControllerFactory: any Factory<LoggedInArguments, UIViewController>

    @Factory(InboxScope.self, factory: \.inboxViewControllerFactory)
    public var inboxViewControllerFactory: any Factory<InboxArguments, UIViewController>
}
