
// TODO: Share with plugin binary.
public enum InitializationType: String {

    // The initializer is run eagerly.
    case eager

    // The initializer is run lazily.
    case lazy
}

// TODO: Share with plugin binary.
public enum ReferenceType: String {

    // The initialized object is retained strongly.
    // Repeated access to the same property will return the same value.
    case strong

    // The initialized object is retained weakly.
    // Repeated access to the same property will return the same value until it is released.
    // Once the object has been released, the next call will create a new instance.
    case weak

    // The initialized object is not retained at all.
    // Repeated access to the same property will a new instance every time.
    case none
}