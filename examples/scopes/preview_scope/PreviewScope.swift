import PreviewFeatureInterface
import PreviewFeatureImplementation
import Saber
import SendToFeatureInterface
import SendToScope
import UIKit

@Injectable
@Injector
public final class PreviewScope {
    @Argument var image: UIImage

    @Factory(SendToScope.self, factory: \.rootFactory)
    public var sendToViewControllerFactory: Factory<SendToScopeArguments, UIViewController>

    @Factory(PreviewViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension PreviewScope: PreviewScopeFulfilledDependencies {}
