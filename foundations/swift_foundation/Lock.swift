import Foundation

/// The when thread safety is enabled for the @Store macro,
/// the expanded code expects there to be a Lock type in scope,
/// with an initializer that takes no arguments and the methods lock() and unlock().
/// The expanded code will use the lock to protect the initialization of the property.
public typealias Lock = NSLock