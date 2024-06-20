import SwiftSyntax

public enum AccessLevel: Comparable, Sendable {
    case accessLevelPrivate
    case accessLevelFilePrivate
    case accessLevelInternal
    case accessLevelPublic
    case accessLevelOpen

    private var integerValue: Int {
        switch self {
        case .accessLevelPrivate: return 0
        case .accessLevelFilePrivate: return 1
        case .accessLevelInternal: return 2
        case .accessLevelPublic: return 3
        case .accessLevelOpen: return 4
        }
    }

    private var stringValue: String {
        switch self {
        case .accessLevelPrivate: "private"
        case .accessLevelFilePrivate: "fileprivate"
        case .accessLevelInternal: "internal"
        case .accessLevelPublic: "public"
        case .accessLevelOpen: "open"
        }
    }

    public var rawValue: String {
        return self.stringValue
    }

    public init?(rawValue: String) {
        switch rawValue {
        case AccessLevel.accessLevelPrivate.stringValue: self = .accessLevelPrivate
        case AccessLevel.accessLevelFilePrivate.stringValue: self = .accessLevelFilePrivate
        case AccessLevel.accessLevelInternal.stringValue: self = .accessLevelInternal
        case AccessLevel.accessLevelPublic.stringValue: self = .accessLevelPublic
        case AccessLevel.accessLevelOpen.stringValue: self = .accessLevelOpen
        default: return nil
        }
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.integerValue < rhs.integerValue
    }
}

public struct Property: Hashable, Sendable {

    // MARK: Initialization

    init(
        accessLevel: AccessLevel,
        label: String,
        typeDescription: TypeDescription
    ) {
        self.accessLevel = accessLevel
        self.label = label
        self.typeDescription = typeDescription
    }

    // MARK: Public

    /// The access level of the property:
    public let accessLevel: AccessLevel

    /// The label by which the property is referenced.
    public let label: String

    /// The type to which the property conforms.
    public let typeDescription: TypeDescription
}
