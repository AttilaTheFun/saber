import CoreLocation
import LocationServiceInterface
import LocationServiceImplementation
import MapFeatureInterface
import MapFeatureImplementation
import Saber
import UIKit

@Injectable
@Injector
public final class MapScope {
    private let locationServiceStore = Store { CLLocationManager() }
    public var locationService: any LocationService {
        self.locationServiceStore.value
    }

    @Factory(MapViewController.self)
    public var rootFactory: Factory<Void, UIViewController>
}

extension MapScope: MapScopeFulfilledDependencies {}
