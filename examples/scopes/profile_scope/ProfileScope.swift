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

    @Once
    @Fulfill(UserSessionServiceImplementationUnownedDependencies.self)
    public lazy var userSessionService: any UserSessionService = self.userSessionServiceOnce { [unowned self] in
        UserSessionServiceImplementation(dependencies: self)
    }

    @Fulfill(ProfileViewControllerDependencies.self)
    public lazy var rootFactory: Factory<Void, UIViewController> = Factory { [unowned self] in
        ProfileViewController(dependencies: self)
    }
}

extension ProfileScope: ProfileScopeFulfilledDependencies {}
