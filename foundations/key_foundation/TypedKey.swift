/**
 Associates a type with a unique name.
 */
public struct TypedKey<T>: Hashable {
    public let name: Name

    public init(name: Name) {
        self.name = name
    }
}
