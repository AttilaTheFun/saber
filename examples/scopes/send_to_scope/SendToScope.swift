import Saber
import SendToFeatureInterface
import SendToFeatureImplementation
import UIKit

@Injectable
@Injector
public final class SendToScope {
    @Argument var image: UIImage

    @Factory(SendToViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension SendToScope: SendToScopeFulfilledDependencies {}
