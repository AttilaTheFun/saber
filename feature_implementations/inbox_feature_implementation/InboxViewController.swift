import DependencyFoundation
import DependencyMacros
import InboxFeatureInterface
import InboxServiceInterface
import UIKit

@Injectable(.viewController)
public final class InboxViewController: UIViewController {
    @Arguments var inboxArguments: InboxArguments
    @Inject var inboxService: any InboxService

    public override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Move this setup to custom init.
        // Configure the tab bar item:
        self.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.init(systemName: "tray.fill"),
            tag: 0
        )

        // Configure the view:
        self.view.backgroundColor = .white
    }
}

