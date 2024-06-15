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

@Injectable
public final class LoadingFeatureViewController: UIViewController {
    @Arguments private let loadingFeature: LoadingFeature
    @Inject private var userSessionStorageService: any UserSessionStorageService
    @Inject private var userService: any UserService
    @Inject private var userStorageService: any UserStorageService
    @Inject private var windowService: any WindowService
    @Inject private var loggedOutFeatureFactory: any Factory<LoggedOutFeature, UIViewController>
    @Inject private var loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController>

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
