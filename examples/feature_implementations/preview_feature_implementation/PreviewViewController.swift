import Saber
import SendToFeatureInterface
import UIKit

@Injectable(UIViewController.self)
public final class PreviewViewController: UIViewController {
    @Inject var sendToViewControllerFactory: Factory<SendToScopeArguments, UIViewController>
}
