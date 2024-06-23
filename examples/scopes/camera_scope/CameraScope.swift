import Saber
import CameraFeatureInterface
import CameraFeatureImplementation
import UIKit

@Injectable
@Scope
public final class CameraScope {

    @Fulfill(CameraViewControllerDependencies.self)
    @Factory(CameraViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension CameraScope: CameraScopeFulfilledDependencies {}
