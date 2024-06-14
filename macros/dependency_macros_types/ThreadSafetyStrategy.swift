
/// The strategy employed for the thread safety of a property annotated with the @Store macro.
/// 
/// Usage:
/// ```
/// @Store(FooServiceImplementation.swift, thread: .safe)
/// var fooService: FooService
/// ````
public enum ThreadSafetyStrategy: String {

    // The property is initalized without a lock.
    // If a thread attempts to access the property while it is being intiialized by another thread, 
    // they may receive different instances.
    // If you know you will exclusively access the property from the main thread and are using Swift Concurrency,
    // you can use the @MainActor annotation to enforce this.
    case unsafe

    // The property is initialized with a lock.
    // If a thread attempts to access the property while it is being intiialized by another thread, 
    // it will wait until the lock is unlocked and receive the same instance.
    case safe
}