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
        self.tabBarItem = UITabBarItem(title: "Inbox", image: UIImage.init(systemName: "tray.fill"), tag: 0)
    }
}

