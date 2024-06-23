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
    @Factory(LoggedInTabBarController.self)
    public var rootFactory: Factory<Void, UIViewController>

    @Fulfill(CameraScopeDependencies.self)
    @Factory(CameraScope.self, factory: \.rootFactory)
    public var cameraViewControllerFactory: Factory<Void, UIViewController>

    @Fulfill(MapScopeDependencies.self)
    @Factory(MapScope.self, factory: \.rootFactory)
    public var mapViewControllerFactory: Factory<Void, UIViewController>

    @Fulfill(InboxScopeDependencies.self)
    @Factory(InboxScope.self, factory: \.rootFactory)
    public var inboxViewControllerFactory: Factory<Void, UIViewController>

    @Fulfill(ProfileScopeDependencies.self)
    @Factory(ProfileScope.self, factory: \.rootFactory)
    public var profileViewControllerFactory: Factory<Void, UIViewController>
}

extension LoggedInScope: LoggedInScopeFulfilledDependencies {}
