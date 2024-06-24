import Saber
import LoggedOutFeatureInterface
import ProfileFeatureInterface
import ProfileFeatureImplementation
import UIKit
import UserServiceInterface
import UserSessionServiceInterface
import UserSessionServiceImplementation
import WindowServiceInterface 

@Injectable
@Injector
public final class ProfileScope {
    @Inject public var user: User
    @Inject public var userSession: UserSession
    @Inject public var userStorageService: any UserStorageService
    @Inject public var userSessionStorageService: any UserSessionStorageService
    @Inject public var windowService: any WindowService
    @Inject public var loggedOutViewControllerFactory: Factory<LoggedOutScopeArguments, UIViewController>

    @Store(UserSessionServiceImplementation.self)
    public var userSessionService: any UserSessionService

    @Factory(ProfileViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension ProfileScope: ProfileScopeFulfilledDependencies {}
