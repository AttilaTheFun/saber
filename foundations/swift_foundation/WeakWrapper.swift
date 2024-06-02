
public final class WeakWrapper<Value: AnyObject> {
    public weak var value: Value?

    public init(value: Value?) {
        self.value = value
    }
}