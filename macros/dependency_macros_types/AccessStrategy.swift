
/// The strategy employed for access to property annotated with the @Store or @Inject macro.
public enum AccessStrategy: String {

    // The property is computed by the receiver on each access.
    // For an @Store property, this will result in a new instance being returned for each access.
    // Fow an @Inject property, each access will obtain the reference from the receiver's dependencies.
    case computed

    // The property is computed by the receiver on inital access and the resulting value is stored strongly.
    case strong

    // The property is computed by the receiver on each access if the stored value has not been initialized yet
    // or it has been released, and the resulting value is stored weakly.
    case weak
}
