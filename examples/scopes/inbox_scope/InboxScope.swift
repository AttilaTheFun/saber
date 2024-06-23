import Saber
import InboxFeatureInterface
import InboxFeatureImplementation
import InboxServiceInterface
import InboxServiceImplementation
import UIKit

@Injectable
@Scope
public final class InboxScope {

    @Fulfill(InboxServiceImplementationUnownedDependencies.self)
    @Once
    public lazy var inboxService: any InboxService = self.inboxServiceOnce { [unowned self] in
        InboxServiceImplementation(dependencies: self)
    }

    @Fulfill(InboxViewControllerDependencies.self)
    @Factory(InboxViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension InboxScope: InboxScopeFulfilledDependencies {}
