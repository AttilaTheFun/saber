import Saber
import LoadingFeatureInterface
import LoadingFeatureInterface
import LoggedOutFeatureInterface
import LoggedInFeatureInterface
import UserServiceInterface
import UserSessionServiceInterface
import UIKit
import WindowServiceInterface

@Injectable(UIViewController.self)
public final class LoadingViewController: UIViewController {
    @Argument private var userSession: UserSession
    @Inject private var userSessionStorageService: any UserSessionStorageService
    @Inject private var userService: any UserService
    @Inject private var userStorageService: any UserStorageService
    @Inject private var windowService: any WindowService
    @Inject private var loggedOutViewControllerFactory: any Factory<LoggedOutViewControllerArguments, UIViewController>
    @Inject private var loggedInTabBarControllerFactory: any Factory<LoggedInTabBarControllerArguments, UIViewController>

    // MARK: View Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the view:
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = .systemBackground
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Task.detached {
            do {
                let user = try await self.userService.getCurrentUser()
                await self.buildLoggedInFeature(userSession: self.userSession, user: user)
            } catch {
                print(error)
                await self.buildLoggedOutFeature()
            }
        }
    }

    // MARK: Private

    @MainActor
    private func buildLoggedInFeature(userSession: UserSession, user: User) {
        self.userStorageService.user = user
        let factory = self.loggedInTabBarControllerFactory
        self.windowService.register {
            let arguments = LoggedInTabBarControllerArguments(userSession: userSession, user: user)
            return factory.build(arguments: arguments)
        }
    }

    @MainActor
    private func buildLoggedOutFeature() {
        self.userSessionStorageService.userSession = nil
        let factory = self.loggedOutViewControllerFactory
        self.windowService.register {
            let arguments = LoggedOutViewControllerArguments()
            return factory.build(arguments: arguments)
        }
    }
}
