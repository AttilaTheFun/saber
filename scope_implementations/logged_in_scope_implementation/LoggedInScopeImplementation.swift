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

@ScopeInjectable
public final class LoggedInScopeImplementation: BaseScope, LoggedInScopeImplementationChildDependencies {
    @Arguments public let loggedInFeature: LoggedInFeature
    @Inject public let userStorageService: UserStorageService
    @Inject public let userSessionStorageService: UserSessionStorageService
    @Inject public let windowService: WindowService
    @Inject public let loggedOutFeatureFactory: any Factory<LoggedOutFeature, UIViewController>

    @Store(UserSessionServiceImplementation.self)
    public let userSessionServiceType: UserSessionService.Type

    @Factory(LoggedInFeatureViewController.self, arguments: LoggedInFeature.self)
    public let loggedInFeatureViewControllerType: UIViewController.Type
}
