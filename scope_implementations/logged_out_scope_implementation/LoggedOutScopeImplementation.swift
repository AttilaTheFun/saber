import DependencyFoundation
import DependencyMacros
import LoggedOutFeatureInterface
import LoggedOutFeatureImplementation
import LoadingFeatureInterface
import SwiftFoundation
import UserSessionServiceInterface
import UserSessionServiceImplementation
import UIKit
import WindowServiceInterface

@ScopeInjectable
public final class LoggedOutScopeImplementation: Scope, LoggedOutScopeImplementationChildDependencies {
    @Arguments public let loggedOutFeature: LoggedOutFeature
    @Inject public let userSessionStorageService: UserSessionStorageService
    @Inject public let windowService: WindowService
    @Inject public let loadingFeatureFactory: any Factory<LoadingFeature, UIViewController>

    @Store(UserSessionServiceImplementation.self)
    public let userSessionServiceType: UserSessionService.Type
    
    @Factory(LoggedOutFeatureViewController.self, arguments: LoggedOutFeature.self)
    public let loggedOutFeatureViewControllerType: UIViewController.Type
}
