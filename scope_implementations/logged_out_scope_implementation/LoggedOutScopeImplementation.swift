import LoggedOutFeatureInterface
import LoggedOutFeatureImplementation
import DependencyFoundation
import LoadingFeatureInterface
import ScopeInitializationPluginInterface
import SwiftFoundation
import UserSessionServiceInterface
import UserSessionServiceImplementation
import UIKit
import WindowServiceInterface

// TODO: Generate with @FeaatureScopeBuilder macro.
public final class LoggedOutFeatureBuilder: DependencyContainer<LoggedOutScopeImplementationDependencies>, Builder {
    public func build(arguments: LoggedOutFeatureArguments) -> UIViewController {
        let scope = LoggedOutScopeImplementation(dependencies: self.dependencies, arguments: arguments)
        return scope.loggedOutFeatureViewControllerBuilder.build(arguments: arguments)
    }
}

// TODO: Generate with @Injectable macro.
public typealias LoggedOutScopeImplementationDependencies
    = DependencyProvider
    & LoadingFeatureBuilderProvider
    & UserSessionStorageServiceProvider
    & WindowServiceProvider

// @FeaatureScopeBuilder(building: UIViewController.self)
// @Injectable
final class LoggedOutScopeImplementation: Scope<LoggedOutScopeImplementationDependencies> {

    // @Arguments
    let loggedOutFeatureArguments: LoggedOutFeatureArguments

    // @Propagate
    // let windowService: WindowService

    // @Propagate
    // let userSessionStorageService: UserSessionStorageService

    // @Propagate
    // let loadingFeatureBuilder: LoadingFeatureBuilder

    // @Instantiate(UserSessionServiceImplementation.self)
    // let userSessionService: UserSessionService

    // @Provide(Builder<LoggedOutFeatureArguments, UIViewController>.self)
    // @Instantiate
    // let loggedOutFeatureBuilder: LoggedOutFeatureBuilder

    // TODO: Generate with @Injectable macro.
    init(dependencies: LoggedOutScopeImplementationDependencies, arguments: LoggedOutFeatureArguments) {
        self.loggedOutFeatureArguments = arguments

        super.init(dependencies: dependencies)
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
extension LoggedOutScopeImplementation: LoadingFeatureBuilderProvider {
    var loadingFeatureBuilder: any Builder<LoadingFeatureArguments, UIViewController> {
        return self.dependencies.loadingFeatureBuilder
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

// TODO: Generate from @Arguments macro.
extension LoggedOutScopeImplementation: LoggedOutFeatureArgumentsProvider {}
