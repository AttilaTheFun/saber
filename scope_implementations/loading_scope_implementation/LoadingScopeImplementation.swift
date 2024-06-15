import DependencyFoundation
import DependencyMacros
import LoadingFeatureInterface
import LoadingFeatureImplementation
import LoggedOutFeatureInterface
import LoggedInFeatureInterface
import SwiftFoundation
import UIKit
import UserSessionServiceInterface
import UserServiceInterface
import UserServiceImplementation
import WindowServiceInterface

@Injectable
public final class LoadingScopeImplementation: LoadingScopeImplementationChildDependencies {
    @Arguments public let loadingFeature: LoadingFeature
    @Inject public var userStorageService: any UserStorageService
    @Inject public var userSessionStorageService: any UserSessionStorageService
    @Inject public var windowService: any WindowService
    @Inject public var loggedOutFeatureFactory: any Factory<LoggedOutFeature, UIViewController>
    @Inject public var loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController>

    @Store(UserServiceImplementation.self)
    public var userService: any UserService

    @Factory(LoadingFeatureViewController.self)
    public var loadingFeatureViewControllerFactory: any Factory<LoadingFeature, UIViewController>
}
