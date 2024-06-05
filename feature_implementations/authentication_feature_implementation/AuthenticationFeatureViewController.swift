import AuthenticationFeatureInterface
import DependencyFoundation
import LoadingScopeInterface
import UserSessionServiceInterface
import UIKit

// TODO: Generate with @Builder macro.
public final class AuthenticationFeatureBuilder: DependencyContainer<AuthenticationFeatureDependencies>, Builder {
    public func build(arguments: AuthenticationFeatureArguments) -> UIViewController {
        return AuthenticationFeatureViewController(dependencies: self.dependencies, arguments: arguments)
    }
}

// TODO: Generate with @Injectable macro.
public typealias AuthenticationFeatureDependencies
    = DependencyProvider
    & LoadingScopeBuilderProvider
    & UserSessionServiceProvider

// @Builder(building: UIViewController.self)
// @Injectable
final class AuthenticationFeatureViewController: UIViewController {

    // @Inject
    private let userSessionService: UserSessionService

    // @Arguments
    private let arguments: AuthenticationFeatureArguments

    // TODO: Generate with @Injectable macro.
    init(dependencies: AuthenticationFeatureDependencies, arguments: AuthenticationFeatureArguments) {
        self.userSessionService = dependencies.userSessionService
        self.arguments = arguments
        super.init(nibName: nil, bundle: nil)
    }

    // TODO: Generate with @Injectable macro.
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}
