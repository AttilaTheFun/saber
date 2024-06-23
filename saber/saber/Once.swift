import Foundation

public typealias Lock = NSLock

public final class Once<Value> {
    private let lock = Lock()
    private var backingValue: Value?

    public init() {}

    public func callAsFunction(initializer: @escaping () -> Value) -> Value {
        if let value = self.backingValue {
            return value
        }
        self.lock.lock()
        defer { self.lock.unlock() }
        if let value = self.backingValue {
            return value
        }
        let value = initializer()
        self.backingValue = value
        return value
    }
}
