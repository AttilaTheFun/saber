import DependencyFoundation
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

@Injectable
public final class RootViewControllerInitializationServiceImplementation: RootViewControllerInitializationService {
    @Inject private let userSessionStorageService: UserSessionStorageService
    @Inject private let userStorageService: UserStorageService
    @Inject private let windowService: WindowService
    @Inject private let loggedOutFeatureFactory: any Factory<LoggedOutFeature, UIViewController>
    @Inject private let loadingFeatureFactory: any Factory<LoadingFeature, UIViewController>
    @Inject private let loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController>

    public func registerRootViewControllerFactory() {
        guard let userSession = self.userSessionStorageService.userSession else {
            self.userSessionStorageService.userSession = nil
            self.userStorageService.user = nil
            let factory = self.loggedOutFeatureFactory
            self.windowService.register {
                let arguments = LoggedOutFeature()
                return factory.build(arguments: arguments)
            }
            return
        }

        guard let user = self.userStorageService.user, user.id == userSession.userID else {
            self.userStorageService.user = nil
            let factory = self.loadingFeatureFactory
            self.windowService.register {
                let arguments = LoadingFeature(userSession: userSession)
                return factory.build(arguments: arguments)
            }
            return
        }

        let factory = self.loggedInFeatureFactory
        self.windowService.register {
            let arguments = LoggedInFeature(userSession: userSession, user: user)
            return factory.build(arguments: arguments)
        }
    }
}
