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

@ScopeViewControllerBuilder(arguments: LoadingFeature.self)

final class LoadingScopeImplementation: BaseScope, LoadingScopeImplementationChildDependencies {
    @Arguments let loadingFeature: LoadingFeature
    @Inject let userStorageService: UserStorageService
    @Inject let userSessionStorageService: UserSessionStorageService
    @Inject let windowService: WindowService
    @Inject let loggedOutFeatureBuilder: any Builder<LoggedOutFeature, UIViewController>
    @Inject let loggedInFeatureBuilder: any Builder<LoggedInFeature, UIViewController>

    // TODO: Generate body with @Instantiate macros.
    @Initialize(UserServiceImplementation.self)
    let userServiceType: UserService.Type

    var userService: any UserService {
        return self.strong { [unowned self] in
            return UserServiceImplementation(dependencies: self)
        }
    }

//    @Instantiate(LoadingFeatureViewControllerBuilder.self)
    var loadingFeatureViewControllerBuilder: any Builder<LoadingFeature, UIViewController> {
        return self.strong { [unowned self] in
            return LoadingFeatureViewControllerBuilder(dependencies: self)
        }
    }
    
    
    private let dependencies: any LoadingScopeImplementationDependencies
    
    public init(
        arguments: LoadingFeature,
        dependencies: any LoadingScopeImplementationDependencies
    ) {
        self.loadingFeature = arguments
        self.dependencies = dependencies
        self.userStorageService = dependencies.userStorageService
        self.userSessionStorageService = dependencies.userSessionStorageService
        self.windowService = dependencies.windowService
        self.loggedOutFeatureBuilder = dependencies.loggedOutFeatureBuilder
        self.loggedInFeatureBuilder = dependencies.loggedInFeatureBuilder
        self.userServiceType = UserServiceImplementation.self
        super.init()
    }
    
    private func initializeUserService() -> any UserService {
        return UserServiceImplementation(dependencies: self)
    }
}

public protocol LoadingScopeImplementationDependencies {
    var userStorageService: UserStorageService {
        get
    }
    var userSessionStorageService: UserSessionStorageService {
        get
    }
    var windowService: WindowService {
        get
    }
    var loggedOutFeatureBuilder: any Builder<LoggedOutFeature, UIViewController> {
        get
    }
    var loggedInFeatureBuilder: any Builder<LoggedInFeature, UIViewController> {
        get
    }
}

public protocol LoadingScopeImplementationChildDependencies
: UserServiceImplementationDependencies
{
}


// TODO: Generate with macro.
extension LoadingScopeImplementation: LoadingFeatureViewControllerDependencies {}
