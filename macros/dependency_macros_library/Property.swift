
public struct Property: Hashable, Sendable {

    // MARK: Initialization

    init(
        label: String,
        typeName: String
    ) {
        self.label = label
        self.typeName = typeName
    }

    // MARK: Public

    /// The label by which the property is referenced.
    public let label: String

    /// The type to which the property conforms.
    public let typeName: String
}
