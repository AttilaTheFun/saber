import Saber
import CameraFeatureInterface
import InboxFeatureInterface
import MapFeatureInterface
import LoggedInFeatureInterface
import UserSessionServiceInterface
import UserServiceInterface
import UIKit
import WindowServiceInterface

@Injectable(UIViewController.self)
public final class LoggedInTabBarController: UITabBarController {
    @Inject public var inboxViewControllerFactory: Factory<Void, UIViewController>
    @Inject public var cameraViewControllerFactory: Factory<Void, UIViewController>
    @Inject public var mapViewControllerFactory: Factory<Void, UIViewController>

    public init(dependencies: any Dependencies) {
        self._dependencies = dependencies
        super.init(nibName: nil, bundle: nil)

        // Configure the tab bar appearance:
        self.configureTabBarAppearance()

        // Create the initial view controllers:
        let viewControllers = [
            self.inboxViewControllerFactory.build(),
            self.cameraViewControllerFactory.build(),
            self.mapViewControllerFactory.build(),
        ]

        // Set the initial view controllers:
        self.viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
        self.selectedIndex = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor.darkText
        appearance.compactInlineLayoutAppearance.normal.iconColor = .lightText
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.lightText]
        appearance.inlineLayoutAppearance.normal.iconColor = .lightText
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.lightText]
        appearance.stackedLayoutAppearance.normal.iconColor = .lightText
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.lightText]

        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        self.tabBar.tintColor = .white
    }
}
