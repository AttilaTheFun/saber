import Saber
import MapFeatureInterface
import MapFeatureImplementation
import UIKit

@Injectable
@Scope
public final class MapScope {

    @Fulfill(MapViewControllerDependencies.self)
    public lazy var rootFactory: Factory<Void, UIViewController> = Factory { [unowned self] in
        MapViewController(dependencies: self)
    }
}

extension MapScope: MapScopeFulfilledDependencies {}
