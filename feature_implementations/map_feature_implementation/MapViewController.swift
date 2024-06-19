import DependencyMacros
import MapFeatureInterface
import MapKit
import UIKit

@Injectable(.viewController)
public final class MapViewController: UIViewController {
    @Arguments var mapArguments: MapArguments
    private let mapView = MKMapView()

    public override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Move this setup to custom init.
        // Configure the tab bar item:
        self.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage.init(systemName: "map.fill"),
            tag: 0
        )

        // Configure the views:
        self.view.backgroundColor = .white
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
