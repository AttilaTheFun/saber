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

// SceneDelegate -> UIWindow -> UIViewController -> Scope -> Other Dependencies
// SceneDelegate -> UIWindow -> UIViewController -> Other Dependencies

@ViewControllerBuilder(arguments: LoadingFeature.self)
@ViewControllerInjectable
final class LoadingFeatureViewController: UIViewController {
    @Arguments private let loadingFeature: LoadingFeature
//    @Inject private var userSessionStorageService: UserSessionStorageService { self.dependencies.userSessionStorageService }
//    @Inject(.lazy) private lazy var userSessionStorageService: UserSessionStorageService = { self.dependencies.userSessionStorageService }()
    @Inject private let userSessionStorageService: UserSessionStorageService
    @Inject private let userService: UserService
    @Inject private let userStorageService: UserStorageService
    @Inject private let windowService: WindowService
    @Inject private let loggedOutFeatureBuilder: any Builder<LoggedOutFeature, UIViewController>
    @Inject private let loggedInFeatureBuilder: any Builder<LoggedInFeature, UIViewController>

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the view:
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = .systemBackground
    }

    override func viewDidAppear(_ animated: Bool) {
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
        let builder = self.loggedInFeatureBuilder
        self.windowService.register {
            let arguments = LoggedInFeature(userSession: userSession, user: user)
            return builder.build(arguments: arguments)
        }
    }

    @MainActor
    private func buildLoggedOutFeature() {
        self.userSessionStorageService.userSession = nil
        let builder = self.loggedOutFeatureBuilder
        self.windowService.register {
            let arguments = LoggedOutFeature()
            return builder.build(arguments: arguments)
        }
    }
}
