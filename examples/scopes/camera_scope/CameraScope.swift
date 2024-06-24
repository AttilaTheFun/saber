import Saber
import CameraFeatureInterface
import CameraFeatureImplementation
import OptionalServiceInterface
import UIKit

@Injectable
@Injector
public final class CameraScope {
    public var optionalService: (any OptionalService)?

    @Factory(CameraViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension CameraScope: CameraScopeFulfilledDependencies {}
