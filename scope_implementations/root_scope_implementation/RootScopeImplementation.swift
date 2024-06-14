import DependencyFoundation
import DependencyMacros
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

public protocol RootScopeImplementationDependencies {

}

//@ScopeInjectable
public final class RootScopeImplementation: BaseScope {
    @Arguments public let rootFeature: RootFeature

    // @Instantiate(type: UserSessionStorageServiceImplementation.self)
    // let userSessionStorageService: UserSessionStorageService

    // @Instantiate(type: UserStorageServiceImplementation.self)
    // let userStorageService: UserStorageService

    // @Instantiate(type: WindowServiceImplementation.self)
    // let windowService: WindowService

    // @Instantiate(type: LoggedOutFeatureViewControllerBuilder.self)
    // let loggedOutScopeBuilder: any Builder<LoggedOutFeature, AnyObject>

    // @Instantiate(type: LoadingFeatureViewControllerBuilder.self)
    // let loadingScopeBuilder: any Builder<LoadingFeature, AnyObject>

    // @Instantiate(type: LoggedInFeatureViewControllerBuilder.self)
    // let loggedInScopeBuilder: any Builder<LoggedInFeature, AnyObject>

    // @Instantiate(type: RootScopeInitializationPluginImplementation.self)
    // let rootScopeInitializationPlugin: ScopeInitializationPlugin

    // TODO: Generate with @Injectable macro.
    public init(dependencies: RootScopeImplementationDependencies, arguments: RootFeature) {
        self.rootFeature = arguments
        super.init()

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

// TODO: Generate with macro.
extension RootScopeImplementation: LoadingScopeImplementationDependencies {}
extension RootScopeImplementation: LoggedInScopeImplementationDependencies {}
extension RootScopeImplementation: LoggedOutScopeImplementationDependencies {}
extension RootScopeImplementation: RootScopeInitializationPluginImplementationDependencies {}
extension RootScopeImplementation: UserSessionStorageServiceImplementationDependencies {}
extension RootScopeImplementation: UserStorageServiceImplementationDependencies {}
extension RootScopeImplementation: WindowServiceImplementationDependencies {}

// TODO: Generate from @Instantiate macros.
extension RootScopeImplementation {
    public var userSessionStorageService: any UserSessionStorageService {
        return self.strong { [unowned self] in
            UserSessionStorageServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate macros.
extension RootScopeImplementation {
    public var userStorageService: any UserStorageService {
        return self.strong { [unowned self] in
            UserStorageServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate macros.
extension RootScopeImplementation {
    public var windowService: any WindowService {
        return self.strong { [unowned self] in
            WindowServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate macros.
extension RootScopeImplementation {
    public var loggedOutFeatureBuilder: any Builder<LoggedOutFeature, UIViewController> {
        return self.strong { [unowned self] in
            LoggedOutScopeImplementationBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate macros.
extension RootScopeImplementation {
    public var loadingFeatureBuilder: any Builder<LoadingFeature, UIViewController> {
        return self.strong { [unowned self] in
            LoadingScopeImplementationBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate macros.
extension RootScopeImplementation {
    public var loggedInFeatureBuilder: any Builder<LoggedInFeature, UIViewController> {
        return self.strong { [unowned self] in
            LoggedInScopeImplementationBuilder(dependencies: self)
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

