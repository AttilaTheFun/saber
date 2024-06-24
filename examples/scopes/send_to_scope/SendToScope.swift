import Saber
import OptionalServiceInterface
import SendToFeatureInterface
import SendToFeatureImplementation
import UIKit

@Injectable
@Injector
public final class SendToScope {
    @Argument public var image: UIImage

    public var optionalService: (any OptionalService)?

    @Factory(SendToViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension SendToScope: SendToScopeFulfilledDependencies {}
