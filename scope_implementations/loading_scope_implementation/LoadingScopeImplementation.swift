import DependencyFoundation
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

// TODO: Generate with @FeaatureScopeBuilder macro.
public final class LoadingFeatureBuilder: DependencyContainer<LoadingScopeImplementationDependencies>, Builder {
    public func build(arguments: LoadingFeatureArguments) -> UIViewController {
        let scope = LoadingScopeImplementation(dependencies: self.dependencies, arguments: arguments)
        return scope.loadingFeatureViewControllerBuilder.build(arguments: arguments)
    }
}

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
final class LoadingScopeImplementation: Scope<LoadingScopeImplementationDependencies> {

    // @Arguments
    let loadingFeatureArguments: LoadingFeatureArguments

    // @Propagate
    // let windowService: WindowService

    // @Propagate
    // let userStorageService: UserStorageService

    // @Propagate
    // let userSessionStorageService: UserSessionStorageService

    // @Propagate
    // let loggedOutFeatureBuilder: LoggedOutFeatureBuilder

    // @Propagate
    // let loggedInFeatureBuilder: LoggedInFeatureBuilder

    // @Instantiate(UserServiceImplementation.self)
    // let userService: UserService

    // @Provide(Builder<LoadingFeatureArguments, UIViewController>.self)
    // @Instantiate
    // let loadingFeatureBuilder: LoadingFeatureBuilder

    // TODO: Generate with @Injectable macro.
    init(dependencies: LoadingScopeImplementationDependencies, arguments: LoadingFeatureArguments) {
        self.loadingFeatureArguments = arguments
        super.init(dependencies: dependencies)
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
extension LoadingScopeImplementation: LoggedOutFeatureBuilderProvider {
    var loggedOutFeatureBuilder: any Builder<LoggedOutFeatureArguments, UIViewController> {
        return self.dependencies.loggedOutFeatureBuilder
    }
}

// TODO: Generate from the @Propagate macro.
extension LoadingScopeImplementation: LoggedInFeatureBuilderProvider {
    var loggedInFeatureBuilder: any Builder<LoggedInFeatureArguments, UIViewController> {
        return self.dependencies.loggedInFeatureBuilder
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
extension LoadingScopeImplementation {
    var loadingFeatureViewControllerBuilder: any Builder<LoadingFeatureArguments, UIViewController> {
        return self.strong { [unowned self] in
            return LoadingFeatureViewControllerBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Arguments macro.
extension LoadingScopeImplementation: LoadingFeatureArgumentsProvider {}

