import DependencyFoundation
import DependencyMacros
import LoggedOutFeatureInterface
import LoggedOutScopeImplementation
import LoadingFeatureInterface
import LoadingScopeImplementation
import LoggedInFeatureInterface
import LoggedInScopeImplementation
import RootFeatureInterface
import RootViewControllerInitializationServiceImplementation
import UserSessionServiceInterface
import UserSessionServiceImplementation
import UserServiceInterface
import UserServiceImplementation
import UIKit
import WindowServiceInterface
import WindowServiceImplementation

@ScopeInjectable
public final class RootScopeImplementation: BaseScope, RootScopeImplementationChildDependencies {
    @Arguments public let rootFeature: RootFeature

    @Store(UserSessionStorageServiceImplementation.self)
    public let userSessionStorageServiceType: UserSessionStorageService.Type

    @Store(UserStorageServiceImplementation.self)
    public let userStorageServiceType: UserStorageService.Type

    @Store(WindowServiceImplementation.self)
    public let windowServiceType: WindowService.Type

    @Store(RootViewControllerInitializationServiceImplementation.self)
    public let rootViewControllerInitializationServiceType: RootViewControllerInitializationService.Type

    // @Factory(LoggedOutFeatureViewController.self, arguments: LoggedOutFeature.self, scope: LoggedOutScope.self)
    // let loggedOutFeatureType: UIViewController.Type

    // @Factory(LoadingFeatureViewController.self, arguments: LoadingFeature.self, scope: LoadingScope.self)
    // let loadingFeatureType: UIViewController.Type

    // @Factory(LoggedInFeatureViewController.self, arguments: LoggedInFeature.self, scope: LoggedInScope.self)
    // let loggedInFeatureType: UIViewController.Type
}

// TODO: Generate with macro.
extension RootScopeImplementation: LoadingScopeImplementationDependencies {}
extension RootScopeImplementation: LoggedInScopeImplementationDependencies {}
extension RootScopeImplementation: LoggedOutScopeImplementationDependencies {}

// TODO: Generate from @Factory macro.
extension RootScopeImplementation {
    public var loggedOutFeatureFactory: any Factory<LoggedOutFeature, UIViewController> {
        FactoryImplementation { arguments in
            let scope = LoggedOutScopeImplementation(arguments: arguments, dependencies: self)
            return scope.loggedOutFeatureViewControllerFactory.build(arguments: arguments)
        }
    }
}

// TODO: Generate from @Factory macro.
extension RootScopeImplementation {
    public var loadingFeatureFactory: any Factory<LoadingFeature, UIViewController> {
        FactoryImplementation { arguments in
            let scope = LoadingScopeImplementation(arguments: arguments, dependencies: self)
            return scope.loadingFeatureViewControllerFactory.build(arguments: arguments)
        }
    }
}

// TODO: Generate from @Factory macros.
extension RootScopeImplementation {
    public var loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController> {
        FactoryImplementation { arguments in
            let scope = LoggedInScopeImplementation(arguments: arguments, dependencies: self)
            return scope.loggedInFeatureViewControllerFactory.build(arguments: arguments)
        }
    }
}
