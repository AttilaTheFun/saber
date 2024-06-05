import DependencyFoundation
import RootScopeInterface
import RootScopeImplementation
import UIKit

@main
final class ApplicationDelegate: UIResponder, UIApplicationDelegate {
    let rootScopeImplementation = RootScopeImplementation(
        dependencies: EmptyDependencyProvider(),
        arguments: RootScopeArguments(endpointURL: URL(string: "https://example.com")!)
    )

    func application(
        _ application: UIApplication, 
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) 
        -> Bool 
    {
        // Override point for customization after application launch.
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
