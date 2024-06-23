import Saber
import LoggedOutFeatureInterface
import LoggedInFeatureInterface
import LoadingFeatureInterface
import UserServiceInterface
import UserSessionServiceInterface
import WindowServiceInterface
import UIKit

public protocol RootViewControllerInitializationService {
    func registerRootViewControllerFactory()
}

@Injectable(dependencies: .unowned)
public final class RootViewControllerInitializationServiceImplementation: RootViewControllerInitializationService {
    @Inject private var userSessionStorageService: UserSessionStorageService
    @Inject private var userStorageService: UserStorageService
    @Inject private var windowService: WindowService
    @Inject private var loggedOutViewControllerFactory: Factory<LoggedOutScopeArguments, UIViewController>
    @Inject private var loadingViewControllerFactory: Factory<LoadingScopeArguments, UIViewController>
    @Inject private var loggedInTabBarControllerFactory: Factory<LoggedInScopeArguments, UIViewController>

    public func registerRootViewControllerFactory() {
        guard let userSession = self.userSessionStorageService.userSession else {
            self.userSessionStorageService.userSession = nil
            self.userStorageService.user = nil
            let factory = self.loggedOutViewControllerFactory
            self.windowService.register {
                let arguments = LoggedOutScopeArguments()
                return factory.build(arguments: arguments)
            }
            return
        }

        guard let user = self.userStorageService.user, user.id == userSession.userID else {
            self.userStorageService.user = nil
            let factory = self.loadingViewControllerFactory
            self.windowService.register {
                let arguments = LoadingScopeArguments(userSession: userSession)
                return factory.build(arguments: arguments)
            }
            return
        }

        let factory = self.loggedInTabBarControllerFactory
        self.windowService.register {
            let arguments = LoggedInScopeArguments(userSession: userSession, user: user)
            return factory.build(arguments: arguments)
        }
    }
}
