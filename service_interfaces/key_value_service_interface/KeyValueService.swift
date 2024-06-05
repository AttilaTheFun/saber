import KeyFoundation

// @Provider
public protocol KeyValueService: AnyObject {

    /// Get the stored value (if any) for the given storage key.
    func get<T>(key: StorageKey<T>) -> T? where T: Codable

    /// Set the given value for the given storage key.
    func set<T>(value: T, for key: StorageKey<T>) where T: Codable

    /// Remove the value for the given name.
    func removeValue<T>(for key: StorageKey<T>) where T: Codable
}

// TODO: Generate with @Provider macro.
public protocol KeyValueServiceProvider {
    var keyValueService: any KeyValueService { get }
}
