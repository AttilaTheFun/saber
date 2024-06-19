import DependencyMacros
import LoggedOutFeatureInterface
import ProfileFeatureInterface
import ProfileFeatureImplementation
import UIKit
import UserServiceInterface
import UserSessionServiceInterface
import UserSessionServiceImplementation
import WindowServiceInterface 

@Injectable
public class ProfileScope {
    @Arguments public var profileArguments: ProfileArguments
    @Inject public var user: User
    @Inject public var userSession: UserSession
    @Inject public var userStorageService: any UserStorageService
    @Inject public var userSessionStorageService: any UserSessionStorageService
    @Inject public var windowService: any WindowService
    @Inject public var loggedOutViewControllerFactory: any Factory<LoggedOutArguments, UIViewController>

    @Store(UserSessionServiceImplementation.self)
    public var userSessionService: any UserSessionService

    @Factory(ProfileViewController.self)
    public var profileViewControllerFactory: any Factory<ProfileArguments, UIViewController>
}
