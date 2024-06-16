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
public final class LoggedInScopeImplementation {
    @Arguments public var loggedInFeature: LoggedInFeature
    @Inject public var userStorageService: any UserStorageService
    @Inject public var userSessionStorageService: any UserSessionStorageService
    @Inject public var windowService: any WindowService
    @Inject public var loggedOutFeatureFactory: any Factory<LoggedOutFeature, UIViewController>

    @Store(UserSessionServiceImplementation.self)
    public var userSessionService: any UserSessionService

    @Factory(LoggedInFeatureViewController.self)
    public var loggedInFeatureViewControllerFactory: any Factory<LoggedInFeature, UIViewController>
}
