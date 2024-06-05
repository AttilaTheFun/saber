import Foundation

public struct Name: Hashable {
    public var identifier: String {
        self.namespace.identifier + "." + self.name
    }

    public let name: String
    public let namespace: Namespace

    public init(name: String, namespace: Namespace) {
        self.name = name
        self.namespace = namespace
    }
}
