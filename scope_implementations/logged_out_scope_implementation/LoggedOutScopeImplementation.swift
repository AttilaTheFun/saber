import LoggedOutFeatureInterface
import LoggedOutFeatureImplementation
import DependencyFoundation
import LoggedOutScopeInterface
import LoggedOutScopeInitializationPluginImplementation
import LoadingScopeInterface
import ScopeInitializationPluginInterface
import SwiftFoundation
import UserSessionServiceInterface
import UserSessionServiceImplementation
import UIKit
import WindowServiceInterface

// TODO: Generate with @Buildable macro.
public final class LoggedOutScopeImplementationBuilder: DependencyContainer<LoggedOutScopeImplementationDependencies>, Builder {
    public func build(arguments: LoggedOutScopeArguments) -> AnyObject {
        return LoggedOutScopeImplementation(dependencies: self.dependencies, arguments: arguments)
    }
}

// TODO: Generate with @Injectable macro.
public typealias LoggedOutScopeImplementationDependencies
    = DependencyProvider
    & LoadingScopeBuilderProvider
    & UserSessionStorageServiceProvider
    & WindowServiceProvider

// @Buildable(building: AnyObject.self)
// @Injectable
final class LoggedOutScopeImplementation: Scope<LoggedOutScopeImplementationDependencies> {

    // @Arguments
    let arguments: LoggedOutScopeArguments

    // @Propagate
    // let windowService: WindowService

    // @Propagate
    // let userSessionStorageService: UserSessionStorageService

    // @Propagate
    // let loadingScopeBuilder: LoadingScopeBuilder

    // @Instantiate(UserSessionServiceImplementation.self)
    // let userSessionService: UserSessionService

    // @Provide(Builder<LoggedOutFeatureArguments, UIViewController>.self)
    // @Instantiate
    // let loggedOutFeatureBuilder: LoggedOutFeatureBuilder

    // @Plugin(ScopeInitializationPlugin.self)
    // @Instantiate
    // let loggedOutScopeInitializationPlugin: LoggedOutScopeInitializationPluginImplementation

    // TODO: Generate with @Injectable macro.
    init(dependencies: LoggedOutScopeImplementationDependencies, arguments: LoggedOutScopeArguments) {
        self.arguments = arguments

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
extension LoggedOutScopeImplementation: WindowServiceProvider {
    var windowService: any WindowService {
        return self.dependencies.windowService
    }
}

// TODO: Generate from the @Propagate macro.
extension LoggedOutScopeImplementation: UserSessionStorageServiceProvider {
    var userSessionStorageService: any UserSessionStorageService {
        return self.dependencies.userSessionStorageService
    }
}

// TODO: Generate from the @Propagate macro.
extension LoggedOutScopeImplementation: LoadingScopeBuilderProvider {
    var loadingScopeBuilder: any Builder<LoadingScopeArguments, AnyObject> {
        return self.dependencies.loadingScopeBuilder
    }
}

// TODO: Generate from the @Instantiate macro.
extension LoggedOutScopeImplementation: UserSessionServiceProvider {
    var userSessionService: any UserSessionService {
        return self.strong { [unowned self] in
            return UserSessionServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from the @Instantiate macro.
extension LoggedOutScopeImplementation: LoggedOutFeatureBuilderProvider {
    var loggedOutFeatureBuilder: any Builder<LoggedOutFeatureArguments, UIViewController> {
        return self.strong { [unowned self] in
            return LoggedOutFeatureBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate macro.
extension LoggedOutScopeImplementation {
    public var loggedOutScopeInitializationPlugin: LoggedOutScopeInitializationPluginImplementation {
        return self.strong { [unowned self] in
            LoggedOutScopeInitializationPluginImplementation(dependencies: self)
        }
    }
}
