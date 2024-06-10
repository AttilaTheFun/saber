import DependencyFoundation
import LoggedInFeatureInterface
import LoggedInFeatureInterface
import LoggedInFeatureImplementation
import LoggedOutFeatureInterface
import ScopeInitializationPluginInterface
import UIKit
import UserServiceInterface
import UserSessionServiceInterface
import UserSessionServiceImplementation
import WindowServiceInterface

// TODO: Generate with @Injectable macro.
public typealias LoggedInScopeImplementationDependencies
    = DependencyProvider
    & LoggedOutFeatureBuilderProvider
    & UserSessionStorageServiceProvider
    & UserStorageServiceProvider
    & WindowServiceProvider

// @Buildable(building: AnyObject.self)
// @Injectable
@ScopeViewControllerBuilder(arguments: LoggedInFeature.self)
final class LoggedInScopeImplementation: Scope<LoggedInScopeImplementationDependencies> {

    // @Arguments
    let loggedInFeature: LoggedInFeature

    // @Propagate(type: UserStorageServiceProvider.self)
    // let userStorageService: UserStorageService

    // @Propagate(type: UserSessionStorageServiceProvider.self
    // let userSessionStorageService: UserSessionStorageService

    // @Propagate(type: WindowServiceProvider.self)
    // let windowService: WindowService

    // @Propagate(type: LoggedOutFeatureBuilderProvider.self)
    // let loggedOutFeatureViewControllerBuilder: any Builder<LoggedOutFeature, UIViewController>

    // @Provide(type: UserSessionServiceProvider.self)
    // @Instantiate(type: UserSessionServiceImplementation.self)
    // let userSessionService: UserSessionService

    // TODO: Generate with @Injectable macro.
    init(dependencies: LoggedInScopeImplementationDependencies, arguments: LoggedInFeature) {
        self.loggedInFeature = arguments
        super.init(dependencies: dependencies)
    }
}

// TODO: Generate from @Arguments macro.
extension LoggedInScopeImplementation: LoggedInFeatureProvider {}

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
    var loggedOutFeatureBuilder: any Builder<LoggedOutFeature, UIViewController> {
        return self.dependencies.loggedOutFeatureBuilder
    }
}

// TODO: Generate from @Provide and @Instantiate macros.
extension LoggedInScopeImplementation: UserSessionServiceProvider {
    var userSessionService: any UserSessionService {
        return self.strong { [unowned self] in
            return UserSessionServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from the @Instantiate macro.
extension LoggedInScopeImplementation {
    var loggedInFeatureViewControllerBuilder: any Builder<LoggedInFeature, UIViewController> {
        return self.strong { [unowned self] in
            return LoggedInFeatureViewControllerBuilder(dependencies: self)
        }
    }
}
