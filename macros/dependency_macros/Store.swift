import Foundation

/// A Store manages an instance which is created lazily.
/// Accessing the building instance is thread-safe.
/// If multiple threads attempt to access the instance while it is being created, they will wait until initialization is complete.
public protocol Store<Value> {
    associatedtype Value
    var value: Value { get }
}
