import Foundation

fileprivate typealias Lock = NSLock

public protocol BackingStore<Building>: AnyObject {
    associatedtype Building

    var building: Building? { get set }
}

public final class StrongBackingStoreImplementation<Building>: BackingStore {
    public var building: Building?
    public init() {}
}

public final class WeakBackingStoreImplementation<Building: AnyObject>: BackingStore {
    public weak var building: Building?
    public init() {}
}

public final class ComputedBackingStoreImplementation<Building: AnyObject>: BackingStore {
    public var building: Building? {
        get { return nil }
        set {}
    }

    public init() {}
}

public final class StoreImplementation<Building>: Store {
    private let backingStore: any BackingStore<Building>
    private let lock = Lock()
    private let function: () -> Building

    public init(
        backingStore: any BackingStore<Building>,
        function: @escaping () -> Building
    ) {
        self.backingStore = backingStore
        self.function = function
    }

    public var building: Building {
        if let building = self.backingStore.building {
            return building
        }
        self.lock.lock()
        defer { self.lock.unlock() }
        if let building = self.backingStore.building {
            return building
        }
        let building = self.function()
        print("Initialized \(building)")
        self.backingStore.building = building
        return building
    }
}
