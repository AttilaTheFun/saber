import Saber
import CameraFeatureInterface
import CameraFeatureImplementation
import OptionalServiceInterface
import PreviewFeatureInterface
import PreviewScope
import UIKit

@Injectable
@Injector
public final class CameraScope {
    public var optionalService: (any OptionalService)?

    @Factory(PreviewScope.self, factory: \.rootFactory)
    public var previewViewControllerFactory: Factory<PreviewScopeArguments, UIViewController>

    @Factory(CameraViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension CameraScope: CameraScopeFulfilledDependencies {}
