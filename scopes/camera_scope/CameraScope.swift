import DependencyMacros
import CameraFeatureInterface
import CameraFeatureImplementation
import UIKit

@Injectable
public final class CameraScope: Scope {
    @Factory(CameraViewController.self)
    public var rootFactory: any Factory<CameraViewController.Arguments, UIViewController>
}
