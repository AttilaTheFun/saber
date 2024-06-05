import DependencyFoundation
import LoggedOutFeatureInterface
import ScopeInitializationPluginInterface
import UIKit
import WindowServiceInterface

// TODO: Generate with @Injectable macro.
public typealias LoggedOutScopeInitializationPluginImplementationDependencies
    = DependencyProvider
    & LoggedOutFeatureBuilderProvider
    & WindowServiceProvider

// @Injectable
public final class LoggedOutScopeInitializationPluginImplementation: ScopeInitializationPlugin {

    // @Inject
    private let windowService: WindowService

    // @Inject
    private let loggedOutFeatureBuilder: any Builder<LoggedOutFeatureArguments, UIViewController>

    // TODO: Generate with @Injectable macro.
    public init(dependencies: LoggedOutScopeInitializationPluginImplementationDependencies) {
        self.windowService = dependencies.windowService
        self.loggedOutFeatureBuilder = dependencies.loggedOutFeatureBuilder
    }

    public func execute() {
        self.windowService.register {
            let arguments = LoggedOutFeatureArguments()
            return self.loggedOutFeatureBuilder.build(arguments: arguments)
        }
    }
}
