import Foundation

fileprivate typealias Lock = NSLock

public protocol BackingStore<Value>: AnyObject {
    associatedtype Value

    var value: Value? { get set }
}

public final class StrongBackingStoreImplementation<Value>: BackingStore {
    public var value: Value?
    public init() {}
}

public final class WeakBackingStoreImplementation<Value: AnyObject>: BackingStore {
    public weak var value: Value?
    public init() {}
}

public final class ComputedBackingStoreImplementation<Value: AnyObject>: BackingStore {
    public var value: Value? {
        get { return nil }
        set {}
    }

    public init() {}
}

public final class StoreImplementation<Value>: Store {
    private let backingStore: any BackingStore<Value>
    private let lock = Lock()
    private let function: () -> Value

    public init(
        backingStore: any BackingStore<Value>,
        function: @escaping () -> Value
    ) {
        self.backingStore = backingStore
        self.function = function
    }

    public var value: Value {
        if let value = self.backingStore.value {
            return value
        }
        self.lock.lock()
        defer { self.lock.unlock() }
        if let value = self.backingStore.value {
            return value
        }
        let value = self.function()
        self.backingStore.value = value
        return value
    }
}
