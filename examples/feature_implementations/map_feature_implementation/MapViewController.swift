import Saber
import LocationServiceInterface
import MapFeatureInterface
import MapKit
import UIKit

@Injectable(UIViewController.self)
public final class MapViewController: UIViewController {
    @Inject var locationService: LocationService
    private let mapView = MKMapView()

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the views:
        self.view.backgroundColor = .black
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.delegate = self
        self.view.addSubview(self.mapView)
        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
}

extension MapViewController: MKMapViewDelegate {}
