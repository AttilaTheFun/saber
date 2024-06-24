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
@Scope
public final class ProfileScope {
    @Inject public var user: User
    @Inject public var userSession: UserSession
    @Inject public var userStorageService: any UserStorageService
    @Inject public var userSessionStorageService: any UserSessionStorageService
    @Inject public var windowService: any WindowService
    @Inject public var loggedOutViewControllerFactory: Factory<LoggedOutScopeArguments, UIViewController>

    @Fulfill(UserSessionServiceImplementationUnownedDependencies.self)
    @Store(UserSessionServiceImplementation.self)
    public var userSessionService: any UserSessionService

    @Fulfill(ProfileViewControllerDependencies.self)
    @Factory(ProfileViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension ProfileScope: ProfileScopeFulfilledDependencies {}
