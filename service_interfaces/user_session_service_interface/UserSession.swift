
public struct UserSession: Hashable, Codable {
    public init(id: UInt64, userID: UInt64, token: String) {
        self.id = id
        self.userID = userID
        self.token = token
    }

    public let id: UInt64
    public let userID: UInt64
    public let token: String
}