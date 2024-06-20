import DependencyMacros
import InboxFeatureInterface
import InboxServiceInterface
import UIKit

@Injectable(UIViewController.self)
public final class InboxViewController: UIViewController {
    @Inject var inboxService: any InboxService

    public init(arguments: Arguments, dependencies: any Dependencies) {
        self._arguments = arguments
        self._dependencies = dependencies
        super.init(nibName: nil, bundle: nil)

        // Configure the tab bar item:
        self.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.init(systemName: "tray.fill"),
            tag: 0
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the view:
        self.view.backgroundColor = .white
    }
}

