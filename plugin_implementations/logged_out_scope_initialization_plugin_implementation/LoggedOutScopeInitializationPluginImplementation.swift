import DependencyFoundation
import AuthenticationFeatureInterface
import ScopeInitializationPluginInterface
import UIKit
import WindowServiceInterface

// TODO: Generate with @Injectable macro.
public typealias LoggedOutScopeInitializationPluginImplementationDependencies
    = DependencyProvider
    & AuthenticationFeatureBuilderProvider
    & WindowServiceProvider

// @Injectable
public final class LoggedOutScopeInitializationPluginImplementation: ScopeInitializationPlugin {

    // @Inject
    private let windowService: WindowService

    // @Inject
    private let authenticationFeatureBuilder: any Builder<AuthenticationFeatureArguments, UIViewController>

    // TODO: Generate with @Injectable macro.
    public init(dependencies: LoggedOutScopeInitializationPluginImplementationDependencies) {
        self.windowService = dependencies.windowService
        self.authenticationFeatureBuilder = dependencies.authenticationFeatureBuilder
    }

    public func execute() {
        self.windowService.register {
            let arguments = AuthenticationFeatureArguments()
            return self.authenticationFeatureBuilder.build(arguments: arguments)
        }
    }
}
