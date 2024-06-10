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
//public final class LoggedOutFeatureBuilder: DependencyContainer<LoggedOutScopeImplementationDependencies>, Builder {
//    public func build(arguments: LoggedOutFeature) -> UIViewController {
//        let scope = LoggedOutScopeImplementation(dependencies: self.dependencies, arguments: arguments)
//        return scope.loggedOutFeatureViewControllerBuilder.build(arguments: arguments)
//    }
//}

// TODO: Generate with @Injectable macro.
public typealias LoggedOutScopeImplementationDependencies
    = DependencyProvider
    & LoadingFeatureBuilderProvider
    & UserSessionStorageServiceProvider
    & WindowServiceProvider

// @FeaatureScopeBuilder(building: UIViewController.self)
// @Injectable
@ScopeViewControllerBuilder(arguments: LoggedOutFeature.self)
final class LoggedOutScopeImplementation: Scope<LoggedOutScopeImplementationDependencies> {

    // @Arguments
    let loggedOutFeature: LoggedOutFeature

    // @Propagate(type: UserSessionStorageServiceProvider.self)
    // let userSessionStorageService: UserSessionStorageService

    // @Propagate(type: WindowServiceProvider.self)
    // let windowService: WindowService

    // @Propagate(type: LoadingFeatureBuilderProvider.self)
    // let loadingFeatureViewControllerBuilder: any Builder<LoadingFeature, UIViewController>

    // @Provide(type: UserSessionServiceProvider.self)
    // @Instantiate(type: UserSessionServiceImplementation.self)
    // let userSessionService: UserSessionService

    // @Instantiate(type: LoggedOutFeatureViewControllerBuilder.self)
    // let loggedOutFeatureViewControllerBuilder: any Builder<LoggedOutFeature, UIViewController>

    // TODO: Generate with @Injectable macro.
    init(dependencies: LoggedOutScopeImplementationDependencies, arguments: LoggedOutFeature) {
        self.loggedOutFeature = arguments
        super.init(dependencies: dependencies)
    }
}

// TODO: Generate from @Arguments macro.
extension LoggedOutScopeImplementation: LoggedOutFeatureProvider {}

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
    var loadingFeatureBuilder: any Builder<LoadingFeature, UIViewController> {
        return self.dependencies.loadingFeatureBuilder
    }
}

// TODO: Generate from @Provide and @Instantiate macros.
extension LoggedOutScopeImplementation: UserSessionServiceProvider {
    var userSessionService: any UserSessionService {
        return self.strong { [unowned self] in
            return UserSessionServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from the @Instantiate macro.
extension LoggedOutScopeImplementation {
    var loggedOutFeatureViewControllerBuilder: any Builder<LoggedOutFeature, UIViewController> {
        return self.strong { [unowned self] in
            return LoggedOutFeatureViewControllerBuilder(dependencies: self)
        }
    }
}
