import Saber
import LoggedOutFeatureInterface
import LoggedOutFeatureImplementation
import LoadingFeatureInterface
import UserSessionServiceInterface
import UserSessionServiceImplementation
import UIKit
import WindowServiceInterface

@Injectable
@Scope
public final class LoggedOutScope {
    public typealias Arguments = LoggedOutScopeArguments

    @Inject public var userSessionStorageService: any UserSessionStorageService
    @Inject public var windowService: any WindowService
    @Inject public var loadingViewControllerFactory: Factory<LoadingScopeArguments, UIViewController>

    @Store(UserSessionServiceImplementation.self)
    public var userSessionService: any UserSessionService

    @Factory(LoggedOutViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension LoggedOutScope: LoggedOutScopeFulfilledDependencies {}
