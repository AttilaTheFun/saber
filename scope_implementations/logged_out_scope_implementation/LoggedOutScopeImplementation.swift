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
    @Inject public let userSessionStorageService: any UserSessionStorageService
    @Inject public let windowService: any WindowService
    @Inject public let loadingFeatureFactory: any Factory<LoadingFeature, UIViewController>

    @Store(UserSessionServiceImplementation.self)
    public var userSessionService: any UserSessionService

    @Factory(LoggedOutFeatureViewController.self)
    public var loggedOutFeatureViewControllerFactory: any Factory<LoggedOutFeature, UIViewController>
}
