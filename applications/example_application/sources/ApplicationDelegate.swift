import DependencyFoundation
import RootFeatureInterface
import RootScopeImplementation
import UIKit

final class ApplicationDependencies: RootScopeImplementationDependencies {}

@main
final class ApplicationDelegate: UIResponder, UIApplicationDelegate {
    let rootScopeImplementation = RootScopeImplementation(
        arguments: RootFeature(endpointURL: URL(string: "https://example.com")!),
        dependencies: ApplicationDependencies()
    )

    func application(
        _ application: UIApplication, 
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) 
        -> Bool 
    {
        self.rootScopeImplementation.rootViewControllerInitializationService.registerRootViewControllerFactory()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication, 
        configurationForConnecting connectingSceneSession: UISceneSession, 
        options: UIScene.ConnectionOptions) 
        -> UISceneConfiguration 
    {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication, 
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>) 
    {
    }
}
