import DependencyFoundation
import LoggedInFeatureInterface
import ScopeInitializationPluginInterface
import UIKit
import WindowServiceInterface

// TODO: Generate with @Injectable macro.
public typealias LoggedInScopeInitializationPluginImplementationDependencies
    = DependencyProvider
    & LoggedInFeatureBuilderProvider
    & WindowServiceProvider

// @Injectable
public final class LoggedInScopeInitializationPluginImplementation: ScopeInitializationPlugin {

    // @Inject
    private let windowService: WindowService

    // @Inject
    private let loggedInFeatureBuilder: any Builder<LoggedInFeatureArguments, UIViewController>

    // TODO: Generate with @Injectable macro.
    public init(dependencies: LoggedInScopeInitializationPluginImplementationDependencies) {
        self.windowService = dependencies.windowService
        self.loggedInFeatureBuilder = dependencies.loggedInFeatureBuilder
    }

    public func execute() {
        self.windowService.register {
            let arguments = LoggedInFeatureArguments()
            return self.loggedInFeatureBuilder.build(arguments: arguments)
        }
    }
}
