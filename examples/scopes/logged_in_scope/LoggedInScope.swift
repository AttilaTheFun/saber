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
public final class LoggedInScope: Scope {
    @Argument public var user: User
    @Argument public var userSession: UserSession
    @Inject public var userStorageService: any UserStorageService
    @Inject public var userSessionStorageService: any UserSessionStorageService
    @Inject public var windowService: any WindowService
    @Inject public var loggedOutViewControllerFactory: any Factory<LoggedOutViewControllerArguments, UIViewController>

    @Factory(LoggedInTabBarController.self)
    public var rootFactory: any Factory<LoggedInTabBarControllerArguments, UIViewController>

    @Factory(CameraScope.self, factory: \.rootFactory)
    public var cameraViewControllerFactory: any Factory<CameraViewControllerArguments, UIViewController>

    @Factory(MapScope.self, factory: \.rootFactory)
    public var mapViewControllerFactory: any Factory<MapViewControllerArguments, UIViewController>

    @Factory(InboxScope.self, factory: \.rootFactory)
    public var inboxViewControllerFactory: any Factory<InboxViewControllerArguments, UIViewController>

    @Factory(ProfileScope.self, factory: \.rootFactory)
    public var profileViewControllerFactory: any Factory<ProfileViewControllerArguments, UIViewController>
}
