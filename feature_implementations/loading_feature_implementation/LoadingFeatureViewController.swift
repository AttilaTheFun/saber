import DependencyFoundation
import LoadingFeatureInterface
import LoadingFeatureInterface
import LoggedOutFeatureInterface
import LoggedInFeatureInterface
import UserServiceInterface
import UserSessionServiceInterface
import UIKit
import WindowServiceInterface

// TODO: Generate with @Builder macro.
public final class LoadingFeatureViewControllerBuilder: DependencyContainer<LoadingFeatureDependencies>, Builder {
    public func build(arguments: LoadingFeatureArguments) -> UIViewController {
        return LoadingFeatureViewController(dependencies: self.dependencies, arguments: arguments)
    }
}

// TODO: Generate with @Injectable macro.
public typealias LoadingFeatureDependencies
    = DependencyProvider
    & LoggedOutFeatureBuilderProvider
    & LoggedInFeatureBuilderProvider
    & UserSessionStorageServiceProvider
    & UserServiceProvider
    & UserStorageServiceProvider
    & WindowServiceProvider

// @Builder(building: UIViewController.self)
// @Injectable
final class LoadingFeatureViewController: UIViewController {

    // @Arguments
    private let loadingFeatureArguments: LoadingFeatureArguments

    // @Inject
    private let userSessionStorageService: UserSessionStorageService

    // @Inject
    private let userService: UserService

    // @Inject
    private let userStorageService: UserStorageService

    // @Inject
    private let windowService: WindowService

    // @Inject
    private let loggedOutFeatureBuilder: any Builder<LoggedOutFeatureArguments, UIViewController>

    // @Inject
    private let loggedInFeatureBuilder: any Builder<LoggedInFeatureArguments, UIViewController>

    // TODO: Generate with @Injectable macro.
    init(dependencies: LoadingFeatureDependencies, arguments: LoadingFeatureArguments) {
        self.loadingFeatureArguments = arguments
        self.userSessionStorageService = dependencies.userSessionStorageService
        self.userService = dependencies.userService
        self.userStorageService = dependencies.userStorageService
        self.windowService = dependencies.windowService
        self.loggedInFeatureBuilder = dependencies.loggedInFeatureBuilder
        self.loggedOutFeatureBuilder = dependencies.loggedOutFeatureBuilder

        super.init(nibName: nil, bundle: nil)
    }

    // TODO: Generate with @Injectable macro.
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

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
                await self.buildLoggedInFeature(userSession: self.loadingFeatureArguments.userSession, user: user)
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
            let arguments = LoggedInFeatureArguments(userSession: userSession, user: user)
            return builder.build(arguments: arguments)
        }
    }

    @MainActor
    private func buildLoggedOutFeature() {
        self.userSessionStorageService.userSession = nil
        let builder = self.loggedOutFeatureBuilder
        self.windowService.register {
            let arguments = LoggedOutFeatureArguments()
            return builder.build(arguments: arguments)
        }
    }
}
