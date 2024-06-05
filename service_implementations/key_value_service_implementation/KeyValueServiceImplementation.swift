import DependencyFoundation
import Foundation
import KeyFoundation
import KeyValueServiceInterface

// TODO: Generate with @Injectable macro.
public typealias KeyValueServiceImplementationDependencies
    = DependencyProvider

// @Injectable
public final class KeyValueServiceImplementation {

    // suiteName: String = Bundle.main.groupIdentifier, prefix: String? = nil
    // UserDefaults(suiteName: suiteName)
    private let prefix: String? = nil
    private let userDefaults: UserDefaults = UserDefaults.standard

    // TODO: Generate with @Injectable macro.
    public init(dependencies: KeyValueServiceImplementationDependencies) {}
}

extension KeyValueServiceImplementation: KeyValueService {
    public func get<T>(key: StorageKey<T>) -> T? where T: Codable {
        let userDefaultsKey = userDefaultsKey(for: key.name)
        guard let data = userDefaults.data(forKey: userDefaultsKey) else {
            return nil
        }

        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }

    public func set<T>(value: T, for key: StorageKey<T>) where T: Codable {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(value) else {
            return
        }

        let userDefaultsKey = userDefaultsKey(for: key.name)
        self.userDefaults.set(data, forKey: userDefaultsKey)
    }

    public func removeValue<T>(for key: StorageKey<T>) where T: Codable {
        let userDefaultsKey = userDefaultsKey(for: key.name)
        self.userDefaults.removeObject(forKey: userDefaultsKey)
    }

    private func userDefaultsKey(for name: Name) -> String {
        var prefix = prefix ?? ""
        prefix = prefix.isEmpty ? prefix : (prefix + ".")
        return prefix + name.identifier
    }
}

public extension Bundle {
    /// The identifier of the app group this app is in.
    var groupIdentifier: String {
        bundleIdentifier.map { "group." + $0 } ?? ""
    }
}
