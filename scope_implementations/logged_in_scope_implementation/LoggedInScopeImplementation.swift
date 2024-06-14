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
public final class LoggedInScopeImplementation: LoggedInScopeImplementationChildDependencies {
    @Arguments public let loggedInFeature: LoggedInFeature
    @Inject public let userStorageService: any UserStorageService
    @Inject public let userSessionStorageService: any UserSessionStorageService
    @Inject public let windowService: any WindowService
    @Inject public let loggedOutFeatureFactory: any Factory<LoggedOutFeature, UIViewController>

    @Store(UserSessionServiceImplementation.self)
    public var userSessionService: any UserSessionService

    @Factory(LoggedInFeatureViewController.self)
    public var loggedInFeatureViewControllerFactory: any Factory<LoggedInFeature, UIViewController>
}
