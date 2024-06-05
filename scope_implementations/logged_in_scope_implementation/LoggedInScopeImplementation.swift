import DependencyFoundation
import LoggedInScopeInterface
import LoggedInFeatureInterface
import LoggedInFeatureImplementation
import LoggedInScopeInitializationPluginImplementation
import LoggedOutFeatureInterface
import ScopeInitializationPluginInterface
import UIKit
import UserServiceInterface
import UserSessionServiceInterface
import UserSessionServiceImplementation
import WindowServiceInterface

// TODO: Generate with @Buildable macro.
public final class LoggedInScopeImplementationBuilder: DependencyContainer<LoggedInScopeImplementationDependencies>, Builder {
    public func build(arguments: LoggedInScopeArguments) -> AnyObject {
        return LoggedInScopeImplementation(dependencies: self.dependencies, arguments: arguments)
    }
}

// TODO: Generate with @Injectable macro.
public typealias LoggedInScopeImplementationDependencies
    = DependencyProvider
    & LoggedOutFeatureBuilderProvider
    & UserSessionStorageServiceProvider
    & UserStorageServiceProvider
    & WindowServiceProvider

// @Buildable(building: AnyObject.self)
// @Injectable
final class LoggedInScopeImplementation: Scope<LoggedInScopeImplementationDependencies> {

    // @Arguments
    let loggedInScopeArguments: LoggedInScopeArguments

    // @Propagate
    // let userStorageService: UserStorageService

    // @Propagate
    // let userSessionStorageService: UserSessionStorageService

    // @Propagate
    // let windowService: WindowService

    // @Propagate
    // let loggedOutFeatureBuilder: LoggedOutFeatureBuilder

    // @Instantiate(UserSessionServiceImplementation.self)
    // let userSessionService: UserSessionService

    // @Plugin(ScopeInitializationPlugin.self)
    // @Instantiate
    // let loggedInScopeInitializationPlugin: LoggedInScopeInitializationPluginImplementation

    // TODO: Generate with @Injectable macro.
    init(dependencies: LoggedInScopeImplementationDependencies, arguments: LoggedInScopeArguments) {
        self.loggedInScopeArguments = arguments
        super.init(dependencies: dependencies)

        // Register Plugins
        let scopeInitializationPlugins: [any ScopeInitializationPlugin] = [
            self.loggedInScopeInitializationPlugin
        ]
        self.registerPlugins(plugins: scopeInitializationPlugins)

        // Execute Scope Initialization Plugins
        for plugin in self.getPlugins(type: ScopeInitializationPlugin.self) {
            plugin.execute()
        }
    }
}

// TODO: Generate from the @Propagate macro.
extension LoggedInScopeImplementation: UserStorageServiceProvider {
    var userStorageService: any UserStorageService {
        return self.dependencies.userStorageService
    }
}

// TODO: Generate from the @Propagate macro.
extension LoggedInScopeImplementation: UserSessionStorageServiceProvider {
    var userSessionStorageService: any UserSessionStorageService {
        return self.dependencies.userSessionStorageService
    }
}

// TODO: Generate from the @Propagate macro.
extension LoggedInScopeImplementation: WindowServiceProvider {
    var windowService: any WindowService {
        return self.dependencies.windowService
    }
}

// TODO: Generate from the @Propagate macro.
extension LoggedInScopeImplementation: LoggedOutFeatureBuilderProvider {
    var loggedOutFeatureBuilder: any Builder<LoggedOutFeatureArguments, UIViewController> {
        return self.dependencies.loggedOutFeatureBuilder
    }
}

// TODO: Generate from the @Instantiate macro.
extension LoggedInScopeImplementation: UserSessionServiceProvider {
    var userSessionService: any UserSessionService {
        return self.strong { [unowned self] in
            return UserSessionServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from the @Instantiate macro.
extension LoggedInScopeImplementation: LoggedInFeatureBuilderProvider {
    var loggedInFeatureBuilder: any Builder<LoggedInFeatureArguments, UIViewController> {
        return self.strong { [unowned self] in
            return LoggedInFeatureBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate macro.
extension LoggedInScopeImplementation {
    public var loggedInScopeInitializationPlugin: LoggedInScopeInitializationPluginImplementation {
        return self.strong { [unowned self] in
            LoggedInScopeInitializationPluginImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from @Arguments macro.
extension LoggedInScopeImplementation: LoggedInScopeArgumentsProvider {}
