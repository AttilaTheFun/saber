import DependencyFoundation
import DependencyMacros
import InboxFeatureInterface
import LoggedInFeatureInterface
import UserSessionServiceInterface
import UserServiceInterface
import UIKit
import WindowServiceInterface

@Injectable(.viewController)
public final class LoggedInTabBarController: UITabBarController {
    @Arguments private var loggedInArguments: LoggedInArguments
    @Inject public var inboxViewControllerFactory: any Factory<InboxArguments, UIViewController>

    public override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Move this setup to custom init.
        let redViewController = UIViewController()
        redViewController.view.backgroundColor = .red
        let blueViewController = UIViewController()
        blueViewController.view.backgroundColor = .blue
        let viewControllers = [
            redViewController,
            self.inboxViewControllerFactory.build(arguments: InboxArguments()),
            blueViewController,
        ]

        self.viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
        self.selectedIndex = 1
    }
}
