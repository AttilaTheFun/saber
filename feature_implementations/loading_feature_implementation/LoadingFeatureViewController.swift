import DependencyFoundation
import LoadingFeatureInterface
import LoadingScopeInterface
import LoggedOutScopeInterface
import LoggedInScopeInterface
import UserServiceInterface
import UserSessionServiceInterface
import UIKit

// TODO: Generate with @Builder macro.
public final class LoadingFeatureBuilder: DependencyContainer<LoadingFeatureDependencies>, Builder {
    public func build(arguments: LoadingFeatureArguments) -> UIViewController {
        return LoadingFeatureViewController(dependencies: self.dependencies, arguments: arguments)
    }
}

// TODO: Generate with @Injectable macro.
public typealias LoadingFeatureDependencies
    = DependencyProvider
    & LoadingScopeArgumentsProvider
    & LoggedInScopeBuilderProvider
    & LoggedOutScopeBuilderProvider
    & UserSessionStorageServiceProvider
    & UserServiceProvider
    & UserStorageServiceProvider

// @Builder(building: UIViewController.self)
// @Injectable
final class LoadingFeatureViewController: UIViewController {

    // @Inject
    private let loadingScopeArguments: LoadingScopeArguments

    // @Inject
    private let userSessionStorageService: UserSessionStorageService

    // @Inject
    private let userService: UserService

    // @Inject
    private let userStorageService: UserStorageService

    // @Inject
    private let loggedInScopeBuilder: any Builder<LoggedInScopeArguments, AnyObject>

    // @Inject
    private let loggedOutScopeBuilder: any Builder<LoggedOutScopeArguments, AnyObject>

    // @Arguments
    private let arguments: LoadingFeatureArguments

    // TODO: Generate with @Injectable macro.
    init(dependencies: LoadingFeatureDependencies, arguments: LoadingFeatureArguments) {
        self.loadingScopeArguments = dependencies.loadingScopeArguments
        self.userSessionStorageService = dependencies.userSessionStorageService
        self.userService = dependencies.userService
        self.userStorageService = dependencies.userStorageService
        self.loggedInScopeBuilder = dependencies.loggedInScopeBuilder
        self.loggedOutScopeBuilder = dependencies.loggedOutScopeBuilder
        self.arguments = arguments
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
                self.userStorageService.user = user
                await self.buildLoggedInScope(userSession: self.loadingScopeArguments.userSession, user: user)
            } catch {
                print(error)
                self.userSessionStorageService.userSession = nil
                await self.buildLoggedOutScope()
            }
        }
    }

    // MARK: Private

    @MainActor
    private func buildLoggedInScope(userSession: UserSession, user: User) {
        let arguments = LoggedInScopeArguments(userSession: userSession, user: user)
        self.loggedInScopeBuilder.build(arguments: arguments)
    }

    @MainActor
    private func buildLoggedOutScope() {
        let arguments = LoggedOutScopeArguments()
        self.loggedOutScopeBuilder.build(arguments: arguments)
    }
}
