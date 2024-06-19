import DependencyMacros
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

@Injectable(.unowned)
public final class RootViewControllerInitializationServiceImplementation: RootViewControllerInitializationService {
    @Inject private var userSessionStorageService: UserSessionStorageService
    @Inject private var userStorageService: UserStorageService
    @Inject private var windowService: WindowService
    @Inject private var loggedOutViewControllerFactory: any Factory<LoggedOutArguments, UIViewController>
    @Inject private var loadingViewControllerFactory: any Factory<LoadingArguments, UIViewController>
    @Inject private var loggedInTabBarControllerFactory: any Factory<LoggedInArguments, UIViewController>

    public func registerRootViewControllerFactory() {
        guard let userSession = self.userSessionStorageService.userSession else {
            self.userSessionStorageService.userSession = nil
            self.userStorageService.user = nil
            let factory = self.loggedOutViewControllerFactory
            self.windowService.register {
                let arguments = LoggedOutArguments()
                return factory.build(arguments: arguments)
            }
            return
        }

        guard let user = self.userStorageService.user, user.id == userSession.userID else {
            self.userStorageService.user = nil
            let factory = self.loadingViewControllerFactory
            self.windowService.register {
                let arguments = LoadingArguments(userSession: userSession)
                return factory.build(arguments: arguments)
            }
            return
        }

        let factory = self.loggedInTabBarControllerFactory
        self.windowService.register {
            let arguments = LoggedInArguments(userSession: userSession, user: user)
            return factory.build(arguments: arguments)
        }
    }
}
