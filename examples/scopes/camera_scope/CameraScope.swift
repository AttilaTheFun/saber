import Saber
import CameraFeatureInterface
import CameraFeatureImplementation
import PreviewFeatureInterface
import PreviewScope
import ProfileFeatureInterface
import ProfileScope
import UIKit

@Injectable
@Injector
public final class CameraScope {

    @Inject
    public var profileViewControllerFactory: Factory<ProfileScopeArguments, UIViewController>

    @Factory(PreviewScope.self, factory: \.rootFactory)
    public var previewViewControllerFactory: Factory<PreviewScopeArguments, UIViewController>

    @Factory(CameraViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension CameraScope: CameraScopeFulfilledDependencies {}
