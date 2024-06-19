import Foundation

/// A Store manages a Building instance which is created lazily.
/// Accessing the building instance is thread-safe.
/// If multiple threads attempt to access the instance while it is being created, they will wait until initialization is complete.
public protocol Store<Building> {
    associatedtype Building

    var building: Building { get }
}
