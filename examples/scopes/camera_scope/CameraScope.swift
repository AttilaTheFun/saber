import Saber
import CameraFeatureInterface
import CameraFeatureImplementation
import UIKit

@Injectable
@Scope
public final class CameraScope {

    @Fulfill(CameraViewControllerDependencies.self)
    public lazy var rootFactory: Factory<Void, UIViewController> = Factory { [unowned self] in
        CameraViewController(dependencies: self.fulfilledDependencies)
    }
}
