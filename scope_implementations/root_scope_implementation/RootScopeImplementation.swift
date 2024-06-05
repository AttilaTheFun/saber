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
    public let rootFeatureArguments: RootFeatureArguments

    // @Provide(UserSessionStorageService.self)
    // @Instantiate
    // let userSessionStorageService: UserSessionStorageServiceImplementation

    // @Provide(UserStorageService.self)
    // @Instantiate
    // let userStorageService: UserStorageServiceImplementation

    // @Provide(WindowService.self)
    // @Instantiate
    // let windowService: WindowServiceImplementation

    // @Provide(Builder<LoggedOutScopeArguments, AnyObject>.self)
    // @Instantiate
    // let loggedOutScopeBuilder: LoggedOutScopeImplementationBuilder

    // @Provide(Builder<LoadingFeatureArguments, AnyObject>.self)
    // @Instantiate
    // let loadingScopeBuilder: LoadingScopeImplementationBuilder

    // @Provide(Builder<LoggedInFeatureArguments, AnyObject>.self)
    // @Instantiate
    // let loggedInScopeBuilder: LoggedInScopeImplementationBuilder

    // @Plugin(ScopeInitializationPlugin.self)
    // @Instantiate
    // let rootScopeInitializationPlugin: RootScopeInitializationPluginImplementation

    // TODO: Generate with @Injectable macro.
    public init(dependencies: RootScopeImplementationDependencies, arguments: RootFeatureArguments) {
        self.rootFeatureArguments = arguments
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

// TODO: Generate from @Instantiate and @Provide macros.
extension RootScopeImplementation: UserSessionStorageServiceProvider {
    public var userSessionStorageService: any UserSessionStorageService {
        return self.strong { [unowned self] in
            UserSessionStorageServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate and @Provide macros.
extension RootScopeImplementation: UserStorageServiceProvider {
    public var userStorageService: any UserStorageService {
        return self.strong { [unowned self] in
            UserStorageServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate and @Provide macros.
extension RootScopeImplementation: WindowServiceProvider {
    public var windowService: any WindowService {
        return self.strong { [unowned self] in
            WindowServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate and @Provide macros.
extension RootScopeImplementation: LoggedOutFeatureBuilderProvider {
    public var loggedOutFeatureBuilder: any Builder<LoggedOutFeatureArguments, UIViewController> {
        return self.strong { [unowned self] in
            LoggedOutFeatureBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate and @Provide macros.
extension RootScopeImplementation: LoadingFeatureBuilderProvider {
    public var loadingFeatureBuilder: any Builder<LoadingFeatureArguments, UIViewController> {
        return self.strong { [unowned self] in
            LoadingFeatureBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate and @Provide macros.
extension RootScopeImplementation: LoggedInFeatureBuilderProvider {
    public var loggedInFeatureBuilder: any Builder<LoggedInFeatureArguments, UIViewController> {
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
extension RootScopeImplementation: RootFeatureArgumentsProvider {}
