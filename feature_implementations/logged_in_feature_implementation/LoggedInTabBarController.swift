import DependencyMacros
import CameraFeatureInterface
import InboxFeatureInterface
import MapFeatureInterface
import LoggedInFeatureInterface
import UserSessionServiceInterface
import UserServiceInterface
import UIKit
import WindowServiceInterface

@Injectable(.viewController)
public final class LoggedInTabBarController: UITabBarController {
    @Arguments private var loggedInArguments: LoggedInArguments
    @Inject public var inboxViewControllerFactory: any Factory<InboxArguments, UIViewController>
    @Inject public var cameraViewControllerFactory: any Factory<CameraArguments, UIViewController>
    @Inject public var mapViewControllerFactory: any Factory<MapArguments, UIViewController>

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the tab bar appearance:
        self.configureTabBarAppearance()

        // TODO: Move this setup to custom init.
        let viewControllers = [
            self.inboxViewControllerFactory.build(arguments: InboxArguments()),
            self.cameraViewControllerFactory.build(arguments: CameraArguments()),
            self.mapViewControllerFactory.build(arguments: MapArguments()),
        ]

        self.viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
        self.selectedIndex = 1
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
