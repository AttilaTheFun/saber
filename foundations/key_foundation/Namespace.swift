import Foundation

/**
 The namespace derives a stable identifier from a type name.
 */
public struct Namespace: RawRepresentable, Hashable {
    public var identifier: String {
        self.rawValue
    }

    public var rawValue: String {
        self.module + "." + self.typeName
    }

    public let module: String
    public let typeName: String

    public init?(rawValue: String) {
        let components = rawValue.split(separator: ".")
        if components.count < 2 {
            return nil
        }

        self.module = components.first.map { String($0) } ?? ""
        self.typeName = components.dropFirst().joined(separator: ".")
    }

    public init(type: (some Any).Type) {
        let fullyQualifiedTypeName = String(reflecting: type)
        self.init(rawValue: fullyQualifiedTypeName)!
    }
}
