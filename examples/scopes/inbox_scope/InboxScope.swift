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
    @Store(InboxServiceImplementation.self)
    public var inboxService: any InboxService

    @Fulfill(InboxViewControllerDependencies.self)
    @Factory(InboxViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension InboxScope: InboxScopeFulfilledDependencies {}
