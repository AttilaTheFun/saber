
public struct Property: Hashable, Sendable {

    // MARK: Initialization

    init(
        label: String,
        typeDescription: TypeDescription
    ) {
        self.label = label
        self.typeDescription = typeDescription
    }

    // MARK: Public

    /// The label by which the property is referenced.
    public let label: String

    /// The type to which the property conforms.
    public let typeDescription: TypeDescription
}
