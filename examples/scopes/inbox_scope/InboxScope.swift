import Saber
import InboxFeatureInterface
import InboxFeatureImplementation
import InboxServiceInterface
import InboxServiceImplementation
import UIKit

@Injectable
public final class InboxScope: Scope {

    @Factory(InboxViewController.self)
    public var rootFactory: any Factory<InboxViewControllerArguments, UIViewController>

    @Store(InboxServiceImplementation.self) public var inboxService: any InboxService
}
