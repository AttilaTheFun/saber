import Saber
import MapFeatureInterface
import MapFeatureImplementation
import UIKit

@Injectable
@Injector
public final class MapScope {

    @Factory(MapViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension MapScope: MapScopeFulfilledDependencies {}
