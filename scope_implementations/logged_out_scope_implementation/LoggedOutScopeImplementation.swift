import AuthenticationFeatureInterface
import AuthenticationFeatureImplementation
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
    & WindowServiceProvider

// @Buildable(building: AnyObject.self)
// @Injectable
final class LoggedOutScopeImplementation: Scope<LoggedOutScopeImplementationDependencies> {

    // @Propagate
    // let windowService: WindowService

    // @Propagate
    // let userSessionStorageService: UserSessionStorageService

    // @Propagate
    // let loadingScopeBuilder: LoadingScopeBuilder

    // @Instantiate(UserSessionServiceImplementation.self)
    // let userSessionService: UserSessionService

    // @Provide(Builder<AuthenticationFeatureArguments, UIViewController>.self)
    // @Instantiate
    // let authenticationFeatureBuilder: AuthenticationFeatureBuilder

    // @Plugin(ScopeInitializationPlugin.self)
    // @Instantiate
    // let loggedOutScopeInitializationPlugin: LoggedOutScopeInitializationPluginImplementation

    // @Arguments
    let arguments: LoggedOutScopeArguments

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

// TODO: Generate from the @Instantiate macro.
extension LoggedOutScopeImplementation: WindowServiceProvider {
    var windowService: any WindowService {
        return self.dependencies.windowService
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
        return UserSessionServiceImplementation(dependencies: self)
    }
}

// TODO: Generate from the @Instantiate macro.
extension LoggedOutScopeImplementation: AuthenticationFeatureBuilderProvider {
    var authenticationFeatureBuilder: any Builder<AuthenticationFeatureArguments, UIViewController> {
        return AuthenticationFeatureBuilder(dependencies: self)
    }
}

// TODO: Generate from @Instantiate macro.
extension LoggedOutScopeImplementation {
    public var loggedOutScopeInitializationPlugin: LoggedOutScopeInitializationPluginImplementation {
        return self.new { [unowned self] in
            LoggedOutScopeInitializationPluginImplementation(dependencies: self)
        }
    }
}
