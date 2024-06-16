
/// The strategy employed to store the property.
public enum StorageStrategy: String {

    // The property is computed by the receiver on inital access and retained strongly.
    // On subsequent access, the retained value is returned.
    case strong

    // The property is computed by the receiver on inital access and retained weakly.
    // On subsequent access, if the retained value still exists, it is returned.
    // Otherwise, it is re-computed and the new value is retained weakly.
    case weak

    // The property is computed by the receiver on every access.
    case computed
}
