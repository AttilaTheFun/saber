import DependencyMacros
import CameraFeatureInterface
import CameraFeatureImplementation
import UIKit

@Injectable
public class CameraScope {
    @Arguments public var cameraArguments: CameraArguments
    @Factory(CameraViewController.self)
    public var cameraViewControllerFactory: any Factory<CameraArguments, UIViewController>
}
