import RootFeatureInterface
import RootScope
import UIKit

final class ApplicationDependencies: RootScopeDependencies {}

@main
final class ApplicationDelegate: UIResponder, UIApplicationDelegate {
    let rootScope = RootScope(
        arguments: RootArguments(endpointURL: URL(string: "https://example.com")!),
        dependencies: ApplicationDependencies()
    )

    func application(
        _ application: UIApplication, 
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) 
        -> Bool 
    {
        self.rootScope.rootViewControllerInitializationService.registerRootViewControllerFactory()
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
