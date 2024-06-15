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

@Injectable
public final class LoggedOutScopeImplementation: LoggedOutScopeImplementationChildDependencies {
    @Arguments public let loggedOutFeature: LoggedOutFeature
    @Inject public var userSessionStorageService: any UserSessionStorageService
    @Inject public var windowService: any WindowService
    @Inject public var loadingFeatureFactory: any Factory<LoadingFeature, UIViewController>

    @Store(UserSessionServiceImplementation.self)
    public var userSessionService: any UserSessionService

    @Factory(LoggedOutFeatureViewController.self)
    public var loggedOutFeatureViewControllerFactory: any Factory<LoggedOutFeature, UIViewController>
}
