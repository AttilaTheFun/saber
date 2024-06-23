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

    @Fulfill(UserSessionServiceImplementationUnownedDependencies.self)
    lazy var userSessionService: any UserSessionService = UserSessionServiceImplementation(dependencies: self.fulfilledDependencies)

    @Fulfill(LoggedOutViewControllerDependencies.self)
    public lazy var rootFactory: Factory<Void, UIViewController> = Factory { [unowned self] in
        LoggedOutViewController(dependencies: self.fulfilledDependencies)
    }
}
