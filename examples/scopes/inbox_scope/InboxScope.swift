import Saber
import InboxFeatureInterface
import InboxFeatureImplementation
import InboxServiceInterface
import InboxServiceImplementation
import UIKit

@Injectable
@Scope
public final class InboxScope {

    @Once
    @Fulfill(InboxServiceImplementationUnownedDependencies.self)
    lazy var inboxService: any InboxService = self.inboxServiceOnce { [unowned self] in
        InboxServiceImplementation(dependencies: self.fulfilledDependencies)
    }

    @Fulfill(InboxViewControllerDependencies.self)
    public lazy var rootFactory: Factory<Void, UIViewController> = Factory { [unowned self] in
        InboxViewController(dependencies: self.fulfilledDependencies)
    }
}
