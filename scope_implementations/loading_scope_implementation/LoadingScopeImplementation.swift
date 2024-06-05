import DependencyFoundation
import LoadingFeatureInterface
import LoadingFeatureImplementation
import LoadingScopeInterface
import LoadingScopeInitializationPluginImplementation
import LoggedOutScopeInterface
import LoggedInScopeInterface
import ScopeInitializationPluginInterface
import UIKit
import UserSessionServiceInterface
import UserServiceInterface
import UserServiceImplementation
import WindowServiceInterface

// TODO: Generate with @Buildable macro.
public final class LoadingScopeImplementationBuilder: DependencyContainer<LoadingScopeImplementationDependencies>, Builder {
    public func build(arguments: LoadingScopeArguments) -> AnyObject {
        return LoadingScopeImplementation(dependencies: self.dependencies, arguments: arguments)
    }
}

// TODO: Generate with @Injectable macro.
public typealias LoadingScopeImplementationDependencies
    = DependencyProvider
    & LoggedInScopeBuilderProvider
    & LoggedOutScopeBuilderProvider
    & UserSessionStorageServiceProvider
    & UserStorageServiceProvider
    & WindowServiceProvider

// @Buildable(building: AnyObject.self)
// @Injectable
final class LoadingScopeImplementation: Scope<LoadingScopeImplementationDependencies> {

    // @Arguments
    let loadingScopeArguments: LoadingScopeArguments

    // @Propagate
    // let windowService: WindowService

    // @Propagate
    // let userStorageService: UserStorageService

    // @Propagate
    // let userSessionStorageService: UserSessionStorageService

    // @Propagate
    // let loggedOutScopeBuilder: LoggedOutScopeBuilder

    // @Propagate
    // let loggedInScopeBuilder: LoggedInScopeBuilder

    // @Instantiate(UserServiceImplementation.self)
    // let userService: UserService

    // @Provide(Builder<LoadingFeatureArguments, UIViewController>.self)
    // @Instantiate
    // let loadingFeatureBuilder: LoadingFeatureBuilder

    // @Plugin(ScopeInitializationPlugin.self)
    // @Instantiate
    // let loadingScopeInitializationPlugin: LoadingScopeInitializationPluginImplementation

    // TODO: Generate with @Injectable macro.
    init(dependencies: LoadingScopeImplementationDependencies, arguments: LoadingScopeArguments) {
        self.loadingScopeArguments = arguments
        super.init(dependencies: dependencies)

        // Register Plugins
        let scopeInitializationPlugins: [any ScopeInitializationPlugin] = [
            self.loggedOutScopeInitializationPlugin
        ]
        self.registerPlugins(plugins: scopeInitializationPlugins)

        // Execute Scope Initialization Plugins
        for plugin in self.getPlugins(type: ScopeInitializationPlugin.self) {
            plugin.execute()
        }
    }
}

// TODO: Generate from the @Propagate macro.
extension LoadingScopeImplementation: WindowServiceProvider {
    var windowService: any WindowService {
        return self.dependencies.windowService
    }
}

// TODO: Generate from the @Propagate macro.
extension LoadingScopeImplementation: UserStorageServiceProvider {
    var userStorageService: any UserStorageService {
        return self.dependencies.userStorageService
    }
}

// TODO: Generate from the @Propagate macro.
extension LoadingScopeImplementation: UserSessionStorageServiceProvider {
    var userSessionStorageService: any UserSessionStorageService {
        return self.dependencies.userSessionStorageService
    }
}

// TODO: Generate from the @Propagate macro.
extension LoadingScopeImplementation: LoggedOutScopeBuilderProvider {
    var loggedOutScopeBuilder: any Builder<LoggedOutScopeArguments, AnyObject> {
        return self.dependencies.loggedOutScopeBuilder
    }
}

// TODO: Generate from the @Propagate macro.
extension LoadingScopeImplementation: LoggedInScopeBuilderProvider {
    var loggedInScopeBuilder: any Builder<LoggedInScopeArguments, AnyObject> {
        return self.dependencies.loggedInScopeBuilder
    }
}

// TODO: Generate from the @Instantiate macro.
extension LoadingScopeImplementation: UserServiceProvider {
    var userService: any UserService {
        return self.strong { [unowned self] in
            return UserServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from the @Instantiate macro.
extension LoadingScopeImplementation: LoadingFeatureBuilderProvider {
    var loadingFeatureBuilder: any Builder<LoadingFeatureArguments, UIViewController> {
        return self.strong { [unowned self] in
            return LoadingFeatureBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate macro.
extension LoadingScopeImplementation {
    public var loggedOutScopeInitializationPlugin: LoadingScopeInitializationPluginImplementation {
        return self.strong { [unowned self] in
            LoadingScopeInitializationPluginImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from @Arguments macro.
extension LoadingScopeImplementation: LoadingScopeArgumentsProvider {}

