import Saber
import MapFeatureInterface
import MapFeatureImplementation
import UIKit

@Injectable
public final class MapScope: Scope {
    @Factory(MapViewController.self)
    public var rootFactory: any Factory<MapViewControllerArguments, UIViewController>
}
