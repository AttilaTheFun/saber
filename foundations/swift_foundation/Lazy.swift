
public final class Lazy<Value> {
    private let factory: () -> Value
    public private(set) lazy var value = self.factory()

    public init(factory: @escaping () -> Value) {
        self.factory = factory
    }
}