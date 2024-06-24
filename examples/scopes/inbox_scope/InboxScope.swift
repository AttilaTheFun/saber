import Saber
import InboxFeatureInterface
import InboxFeatureImplementation
import InboxServiceInterface
import InboxServiceImplementation
import UIKit

@Injectable
@Injector
public final class InboxScope {

    @Store(InboxServiceImplementation.self)
    public var inboxService: any InboxService

    @Factory(InboxViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension InboxScope: InboxScopeFulfilledDependencies {}
