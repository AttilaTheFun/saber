import Foundation

public typealias Lock = NSLock

public final class Store<Value> {
    private let lock = Lock()
    private let initializer: () -> Value
    private var backingValue: Value?

    public init(initializer: @escaping () -> Value) {
        self.initializer = initializer
    }

    public var value: Value {
        if let value = self.backingValue {
            return value
        }
        self.lock.lock()
        defer { self.lock.unlock() }
        if let value = self.backingValue {
            return value
        }
        let value = self.initializer()
        self.backingValue = value
        return value
    }
}
