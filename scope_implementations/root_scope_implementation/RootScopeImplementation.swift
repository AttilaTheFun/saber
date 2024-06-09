import DependencyFoundation
import LoggedOutFeatureInterface
import LoggedOutScopeImplementation
import LoadingFeatureInterface
import LoadingScopeImplementation
import LoggedInFeatureInterface
import LoggedInScopeImplementation
import RootFeatureInterface
import RootScopeInitializationPluginImplementation
import ScopeInitializationPluginInterface
import UserSessionServiceInterface
import UserSessionServiceImplementation
import UserServiceInterface
import UserServiceImplementation
import UIKit
import WindowServiceInterface
import WindowServiceImplementation

// TODO: Generate with @Injectable macro.
public typealias RootScopeImplementationDependencies
    = DependencyProvider

// @Injectable
@MainActor
public final class RootScopeImplementation: Scope<RootScopeImplementationDependencies> {

    // @Arguments
    public let rootFeature: RootFeature

    // @Provide(type: UserSessionStorageServiceProvider.self)
    // @Instantiate(type: UserSessionStorageServiceImplementation.self)
    // let userSessionStorageService: UserSessionStorageService

    // @Provide(type: UserStorageServiceProvider.self)
    // @Instantiate(type: UserStorageServiceImplementation.self)
    // let userStorageService: UserStorageService

    // @Provide(type: WindowServiceProvider.self)
    // @Instantiate(type: WindowServiceImplementation.self)
    // let windowService: WindowService

    // @Provide(type: LoggedOutFeatureBuilderProvider.self)
    // @Instantiate(type: LoggedOutFeatureBuilder.self)
    // let loggedOutScopeBuilder: any Builder<LoggedOutFeature, AnyObject>

    // @Provide(type: LoadingFeatureBuilderProvider.self)
    // @Instantiate(type: LoadingFeatureBuilder.self)
    // let loadingScopeBuilder: any Builder<LoadingFeature, AnyObject>

    // @Provide(type: LoggedInFeatureBuilderProvider.self)
    // @Instantiate(type: LoggedInFeatureBuilder.self)
    // let loggedInScopeBuilder: any Builder<LoggedInFeature, AnyObject>

    // @Plugin(type: ScopeInitializationPlugin.self)
    // @Instantiate(type: RootScopeInitializationPluginImplementation.self)
    // let rootScopeInitializationPlugin: ScopeInitializationPlugin

    // TODO: Generate with @Injectable macro.
    public init(dependencies: RootScopeImplementationDependencies, arguments: RootFeature) {
        self.rootFeature = arguments
        super.init(dependencies: dependencies)

        // Register Plugins
        let scopeInitializationPlugins: [any ScopeInitializationPlugin] = [
            self.rootScopeInitializationPlugin
        ]
        self.registerPlugins(plugins: scopeInitializationPlugins)

        // Execute Scope Initialization Plugins
        for plugin in self.getPlugins(type: ScopeInitializationPlugin.self) {
            plugin.execute()
        }
    }
}

// TODO: Generate from @Provide and @Instantiate macros.
extension RootScopeImplementation: UserSessionStorageServiceProvider {
    public var userSessionStorageService: any UserSessionStorageService {
        return self.strong { [unowned self] in
            UserSessionStorageServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from @Provide and @Instantiate macros.
extension RootScopeImplementation: UserStorageServiceProvider {
    public var userStorageService: any UserStorageService {
        return self.strong { [unowned self] in
            UserStorageServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from @Provide and @Instantiate macros.
extension RootScopeImplementation: WindowServiceProvider {
    public var windowService: any WindowService {
        return self.strong { [unowned self] in
            WindowServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from @Provide and @Instantiate macros.
extension RootScopeImplementation: LoggedOutFeatureBuilderProvider {
    public var loggedOutFeatureBuilder: any Builder<LoggedOutFeature, UIViewController> {
        return self.strong { [unowned self] in
            LoggedOutFeatureBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Provide and @Instantiate macros.
extension RootScopeImplementation: LoadingFeatureBuilderProvider {
    public var loadingFeatureBuilder: any Builder<LoadingFeature, UIViewController> {
        return self.strong { [unowned self] in
            LoadingFeatureBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Provide and @Instantiate macros.
extension RootScopeImplementation: LoggedInFeatureBuilderProvider {
    public var loggedInFeatureBuilder: any Builder<LoggedInFeature, UIViewController> {
        return self.strong { [unowned self] in
            LoggedInFeatureBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate macro.
extension RootScopeImplementation {
    public var rootScopeInitializationPlugin: RootScopeInitializationPluginImplementation {
        return self.strong { [unowned self] in
            RootScopeInitializationPluginImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from @Arguments macro.
extension RootScopeImplementation: RootFeatureProvider {}
