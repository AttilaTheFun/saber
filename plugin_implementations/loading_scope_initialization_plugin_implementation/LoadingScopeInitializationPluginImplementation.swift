import DependencyFoundation
import LoadingFeatureInterface
import ScopeInitializationPluginInterface
import UIKit
import WindowServiceInterface

// TODO: Generate with @Injectable macro.
public typealias LoadingScopeInitializationPluginImplementationDependencies
    = DependencyProvider
    & LoadingFeatureBuilderProvider
    & WindowServiceProvider

// @Injectable
public final class LoadingScopeInitializationPluginImplementation: ScopeInitializationPlugin {

    // @Inject
    private let windowService: WindowService

    // @Inject
    private let loadingFeatureBuilder: any Builder<LoadingFeatureArguments, UIViewController>

    // TODO: Generate with @Injectable macro.
    public init(dependencies: LoadingScopeInitializationPluginImplementationDependencies) {
        self.windowService = dependencies.windowService
        self.loadingFeatureBuilder = dependencies.loadingFeatureBuilder
    }

    public func execute() {
        self.windowService.register {
            let arguments = LoadingFeatureArguments()
            return self.loadingFeatureBuilder.build(arguments: arguments)
        }
    }
}
