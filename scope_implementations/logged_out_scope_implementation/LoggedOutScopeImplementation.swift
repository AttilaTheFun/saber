import LoggedOutFeatureInterface
import LoggedOutFeatureImplementation
import DependencyFoundation
import LoggedOutScopeInitializationPluginImplementation
import LoadingScopeInterface
import ScopeInitializationPluginInterface
import SwiftFoundation
import UserSessionServiceInterface
import UserSessionServiceImplementation
import UIKit
import WindowServiceInterface

// TODO: Generate with @Buildable macro.
public final class LoggedOutFeatureBuilder: DependencyContainer<LoggedOutScopeImplementationDependencies>, Builder {
    public func build(arguments: LoggedOutFeatureArguments) -> UIViewController {
        let scope = LoggedOutScopeImplementation(dependencies: self.dependencies, arguments: arguments)
        return scope.loggedOutFeatureViewControllerBuilder.build(arguments: arguments)
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
    let loggedOutFeatureArguments: LoggedOutFeatureArguments

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
    init(dependencies: LoggedOutScopeImplementationDependencies, arguments: LoggedOutFeatureArguments) {
        self.loggedOutFeatureArguments = arguments

        super.init(dependencies: dependencies)

//        // Register Plugins
//        let scopeInitializationPlugins: [any ScopeInitializationPlugin] = [
//            self.loggedOutScopeInitializationPlugin
//        ]
//        self.registerPlugins(plugins: scopeInitializationPlugins)
//
//        // Execute Scope Initialization Plugins
//        for plugin in self.getPlugins(type: ScopeInitializationPlugin.self) {
//            plugin.execute()
//        }
    }
}

// TODO: Generate from the @Propagate macro.
extension LoggedOutScopeImplementation: UserSessionStorageServiceProvider {
    var userSessionStorageService: any UserSessionStorageService {
        return self.dependencies.userSessionStorageService
    }
}

// TODO: Generate from the @Propagate macro.
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
        return self.strong { [unowned self] in
            return UserSessionServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from the @Instantiate macro.
extension LoggedOutScopeImplementation {
    var loggedOutFeatureViewControllerBuilder: any Builder<LoggedOutFeatureArguments, UIViewController> {
        return self.strong { [unowned self] in
            return LoggedOutFeatureViewControllerBuilder(dependencies: self)
        }
    }
}

//// TODO: Generate from @Instantiate macro.
//extension LoggedOutScopeImplementation {
//    public var loggedOutScopeInitializationPlugin: LoggedOutScopeInitializationPluginImplementation {
//        return self.strong { [unowned self] in
//            LoggedOutScopeInitializationPluginImplementation(dependencies: self)
//        }
//    }
//}

// TODO: Generate from @Arguments macro.
extension LoggedOutScopeImplementation: LoggedOutFeatureArgumentsProvider {}
