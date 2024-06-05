import DependencyFoundation
import LoggedInScopeInterface
import LoggedInScopeImplementation
import LoggedOutScopeInterface
import LoggedOutScopeImplementation
import LoadingScopeInterface
import LoadingScopeImplementation
import RootScopeInterface
import RootScopeInitializationPluginImplementation
import ScopeInitializationPluginInterface
import UserSessionServiceInterface
import UserSessionServiceImplementation
import UserServiceInterface
import UserServiceImplementation
import WindowServiceInterface
import WindowServiceImplementation

// TODO: Generate with @Injectable macro.
public typealias RootScopeImplementationDependencies
    = DependencyProvider

// @Injectable
public final class RootScopeImplementation: Scope<RootScopeImplementationDependencies> {

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

    // @Provide(Builder<LoadingScopeArguments, AnyObject>.self)
    // @Instantiate
    // let loadingScopeBuilder: LoadingScopeImplementationBuilder

    // @Provide(Builder<LoggedInScopeArguments, AnyObject>.self)
    // @Instantiate
    // let loggedInScopeBuilder: LoggedInScopeImplementationBuilder

    // @Plugin(ScopeInitializationPlugin.self)
    // @Instantiate
    // let rootScopeInitializationPlugin: RootScopeInitializationPluginImplementation

    // @Arguments
    public let rootScopeArguments: RootScopeArguments

    // TODO: Generate with @Injectable macro.
    public init(dependencies: RootScopeImplementationDependencies, arguments: RootScopeArguments) {
        self.rootScopeArguments = arguments
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
extension RootScopeImplementation: LoggedOutScopeBuilderProvider {
    public var loggedOutScopeBuilder: any Builder<LoggedOutScopeArguments, AnyObject> {
        return self.new { [unowned self] in
            LoggedOutScopeImplementationBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate and @Provide macros.
extension RootScopeImplementation: LoadingScopeBuilderProvider {
    public var loadingScopeBuilder: any Builder<LoadingScopeArguments, AnyObject> {
        return self.new { [unowned self] in
            LoadingScopeImplementationBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate and @Provide macros.
extension RootScopeImplementation: LoggedInScopeBuilderProvider {
    public var loggedInScopeBuilder: any Builder<LoggedInScopeArguments, AnyObject> {
        return self.new { [unowned self] in
            LoggedInScopeImplementationBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate macro.
extension RootScopeImplementation {
    public var rootScopeInitializationPlugin: RootScopeInitializationPluginImplementation {
        return self.new { [unowned self] in
            RootScopeInitializationPluginImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from @Arguments macro.
extension RootScopeImplementation: RootScopeArgumentsProvider {}
