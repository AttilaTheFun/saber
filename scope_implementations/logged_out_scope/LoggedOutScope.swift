import DependencyFoundation
import DependencyMacros
import LoggedOutFeatureInterface
import LoggedOutFeatureImplementation
import LoadingFeatureInterface
import UserSessionServiceInterface
import UserSessionServiceImplementation
import UIKit
import WindowServiceInterface

@Injectable
public final class LoggedOutScope {
    @Arguments public var loggedOutArguments: LoggedOutArguments
    @Inject public var userSessionStorageService: any UserSessionStorageService
    @Inject public var windowService: any WindowService
    @Inject public var loadingViewControllerFactory: any Factory<LoadingArguments, UIViewController>

    @Store(UserSessionServiceImplementation.self)
    public var userSessionService: any UserSessionService

    @Factory(LoggedOutViewController.self)
    public var loggedOutViewControllerFactory: any Factory<LoggedOutArguments, UIViewController>
}
