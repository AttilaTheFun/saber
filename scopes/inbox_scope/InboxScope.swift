import DependencyMacros
import InboxFeatureInterface
import InboxFeatureImplementation
import InboxServiceInterface
import InboxServiceImplementation
import UIKit

@Injectable
public class InboxScope {
    @Arguments public var inboxArguments: InboxArguments
    @Store(InboxServiceImplementation.self) public var inboxService: any InboxService
    @Factory(InboxViewController.self)
    public var inboxViewControllerFactory: any Factory<InboxArguments, UIViewController>
}
