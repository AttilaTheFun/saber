import CameraFeatureInterface
import CameraScope
import Saber
import InboxFeatureInterface
import InboxScope
import MapFeatureInterface
import MapScope
import LoggedInFeatureInterface
import LoggedInFeatureImplementation
import LoggedOutFeatureInterface
import ProfileFeatureInterface
import ProfileScope
import UIKit
import UserServiceInterface
import UserSessionServiceInterface
import WindowServiceInterface

@Injectable
@Scope
public final class LoggedInScope {
    @Argument public var user: User
    @Argument public var userSession: UserSession
    @Inject public var userStorageService: any UserStorageService
    @Inject public var userSessionStorageService: any UserSessionStorageService
    @Inject public var windowService: any WindowService
    @Inject public var loggedOutViewControllerFactory: Factory<LoggedOutScopeArguments, UIViewController>

    @Fulfill(LoggedInTabBarControllerDependencies.self)
    public lazy var rootFactory: Factory<Void, UIViewController> = Factory { [unowned self] in
        return LoggedInTabBarController(dependencies: self.fulfilledDependencies)
    }

    @Fulfill(CameraScopeDependencies.self)
    public lazy var cameraViewControllerFactory: Factory<Void, UIViewController> = Factory { [unowned self] in
        CameraScope(dependencies: self.fulfilledDependencies).rootFactory.build()
    }

    @Fulfill(MapScopeDependencies.self)
    public lazy var mapViewControllerFactory: Factory<Void, UIViewController> = Factory { [unowned self] in
        MapScope(dependencies: self.fulfilledDependencies).rootFactory.build()
    }

    @Fulfill(InboxScopeDependencies.self)
    public lazy var inboxViewControllerFactory: Factory<Void, UIViewController> = Factory { [unowned self] in
        InboxScope(dependencies: self.fulfilledDependencies).rootFactory.build()
    }

    @Fulfill(ProfileScopeDependencies.self)
    public lazy var profileViewControllerFactory: Factory<Void, UIViewController> = Factory { [unowned self] in
        ProfileScope(dependencies: self.fulfilledDependencies).rootFactory.build()
    }
}
