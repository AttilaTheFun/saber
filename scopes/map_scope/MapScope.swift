import DependencyFoundation
import DependencyMacros
import MapFeatureInterface
import MapFeatureImplementation
import UIKit

@Injectable
public class MapScope {
    @Arguments public var mapArguments: MapArguments
    @Factory(MapViewController.self)
    public var mapViewControllerFactory: any Factory<MapArguments, UIViewController>
}
