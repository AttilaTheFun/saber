import DependencyFoundation
import DependencyMacros
import LoadingFeatureInterface
import LoadingFeatureImplementation
import LoggedOutFeatureInterface
import LoggedInFeatureInterface
import ScopeInitializationPluginInterface
import UIKit
import UserSessionServiceInterface
import UserServiceInterface
import UserServiceImplementation
import WindowServiceInterface

// TODO: Generate with @Injectable macro.
public typealias LoadingScopeImplementationDependencies
    = DependencyProvider
    & LoggedInFeatureBuilderProvider
    & LoggedOutFeatureBuilderProvider
    & UserSessionStorageServiceProvider
    & UserStorageServiceProvider
    & WindowServiceProvider

// @FeaatureScopeBuilder(building: UIViewController.self)
// @Injectable
@ScopeViewControllerBuilder(arguments: LoadingFeature.self)
final class LoadingScopeImplementation: Scope<LoadingScopeImplementationDependencies> {

    // @Arguments
    let loadingFeature: LoadingFeature

    // @Propagate(type: UserStorageServiceProvider.self)
    // let userStorageService: UserStorageService

    // @Propagate(type: UserSessionStorageServiceProvider.self)
    // let userSessionStorageService: UserSessionStorageService

    // @Propagate(type: WindowServiceProvider.self)
    // let windowService: WindowService

    // @Propagate(type: LoggedOutFeatureBuilderProvider.self)
    // let loggedOutFeatureViewControllerBuilder: any Builder<LoggedOutFeature, UIViewController>

    // @Propagate(type: LoggedInFeatureBuilderProvider.self)
    // let loggedInFeatureViewControllerBuilder: any Builder<LoggedInFeature, UIViewController>

    // @Provide(type: UserServiceProvider.self)
    // @Instantiate(type: UserServiceImplementation.self)
    // let userService: UserService

    // @Instantiate(type: LoadingFeatureViewControllerBuilder.self)
    // let loadingFeatureViewControllerBuilder: any Builder<LoadingFeature, UIViewController>

    // TODO: Generate with @Injectable macro.
    init(dependencies: LoadingScopeImplementationDependencies, arguments: LoadingFeature) {
        self.loadingFeature = arguments
        super.init(dependencies: dependencies)
    }
}

// TODO: Generate from @Arguments macro.
extension LoadingScopeImplementation: LoadingFeatureProvider {}

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
extension LoadingScopeImplementation: LoggedOutFeatureBuilderProvider {
    var loggedOutFeatureBuilder: any Builder<LoggedOutFeature, UIViewController> {
        return self.dependencies.loggedOutFeatureBuilder
    }
}

// TODO: Generate from the @Propagate macro.
extension LoadingScopeImplementation: LoggedInFeatureBuilderProvider {
    var loggedInFeatureBuilder: any Builder<LoggedInFeature, UIViewController> {
        return self.dependencies.loggedInFeatureBuilder
    }
}

// TODO: Generate from @Provide and @Instantiate macros.
extension LoadingScopeImplementation: UserServiceProvider {
    var userService: any UserService {
        return self.strong { [unowned self] in
            return UserServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from the @Instantiate macro.
extension LoadingScopeImplementation {
    var loadingFeatureViewControllerBuilder: any Builder<LoadingFeature, UIViewController> {
        return self.strong { [unowned self] in
            return LoadingFeatureViewControllerBuilder(dependencies: self)
        }
    }
}
