import DependencyFoundation
import DependencyMacros
import LoadingFeatureInterface
import LoadingFeatureInterface
import LoggedOutFeatureInterface
import LoggedInFeatureInterface
import UserServiceInterface
import UserSessionServiceInterface
import UIKit
import WindowServiceInterface

@ViewControllerInjectable
public final class LoadingFeatureViewController: UIViewController {
    @Arguments private let loadingFeature: LoadingFeature
    @Inject private let userSessionStorageService: UserSessionStorageService
    @Inject private let userService: UserService
    @Inject private let userStorageService: UserStorageService
    @Inject private let windowService: WindowService
    @Inject private let loggedOutFeatureFactory: any Factory<LoggedOutFeature, UIViewController>
    @Inject private let loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController>

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
                await self.buildLoggedInFeature(userSession: self.loadingFeature.userSession, user: user)
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
        let factory = self.loggedInFeatureFactory
        self.windowService.register {
            let arguments = LoggedInFeature(userSession: userSession, user: user)
            return factory.build(arguments: arguments)
        }
    }

    @MainActor
    private func buildLoggedOutFeature() {
        self.userSessionStorageService.userSession = nil
        let factory = self.loggedOutFeatureFactory
        self.windowService.register {
            let arguments = LoggedOutFeature()
            return factory.build(arguments: arguments)
        }
    }
}
