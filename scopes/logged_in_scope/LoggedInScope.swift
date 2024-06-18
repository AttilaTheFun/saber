import CameraFeatureInterface
import CameraScope
import DependencyFoundation
import DependencyMacros
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
public final class LoggedInScope {
    @Arguments public var loggedInArguments: LoggedInArguments
    @Argument public var user: User
    @Argument public var userSession: UserSession
    @Inject public var userStorageService: any UserStorageService
    @Inject public var userSessionStorageService: any UserSessionStorageService
    @Inject public var windowService: any WindowService
    @Inject public var loggedOutViewControllerFactory: any Factory<LoggedOutArguments, UIViewController>

    @Factory(LoggedInTabBarController.self)
    public var loggedInTabBarControllerFactory: any Factory<LoggedInArguments, UIViewController>

    @Factory(CameraScope.self, factory: \.cameraViewControllerFactory)
    public var cameraViewControllerFactory: any Factory<CameraArguments, UIViewController>

    @Factory(MapScope.self, factory: \.mapViewControllerFactory)
    public var mapViewControllerFactory: any Factory<MapArguments, UIViewController>

    @Factory(InboxScope.self, factory: \.inboxViewControllerFactory)
    public var inboxViewControllerFactory: any Factory<InboxArguments, UIViewController>

    @Factory(ProfileScope.self, factory: \.profileViewControllerFactory)
    public var profileViewControllerFactory: any Factory<ProfileArguments, UIViewController>
}
