import Saber
import MapFeatureInterface
import MapFeatureImplementation
import UIKit

@Injectable
@Scope
public final class MapScope {

    @Fulfill(MapViewControllerDependencies.self)
    @Factory(MapViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension MapScope: MapScopeFulfilledDependencies {}
