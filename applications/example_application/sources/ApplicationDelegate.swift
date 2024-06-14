import DependencyFoundation
import RootFeatureInterface
import RootScopeImplementation
import UIKit

final class ApplicationDependencies: RootScopeImplementationDependencies {}

@main
final class ApplicationDelegate: UIResponder, UIApplicationDelegate {
    let rootScopeImplementation = RootScopeImplementation(
        dependencies: ApplicationDependencies(),
        arguments: RootFeature(endpointURL: URL(string: "https://example.com")!)
    )

    func application(
        _ application: UIApplication, 
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) 
        -> Bool 
    {
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
