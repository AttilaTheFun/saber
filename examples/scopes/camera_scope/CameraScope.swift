import Saber
import CameraFeatureInterface
import CameraFeatureImplementation
import UIKit

@Injectable
@Injector
public final class CameraScope {

    @Factory(CameraViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension CameraScope: CameraScopeFulfilledDependencies {}
