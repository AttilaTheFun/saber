import CoreLocation

public protocol LocationService {
    var authorizationStatus: CLAuthorizationStatus { get }
    func requestWhenInUseAuthorization()
}
