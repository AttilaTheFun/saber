import Foundation

public struct UserSession: Hashable, Codable {
    public init(id: UUID, userID: UUID, token: String) {
        self.id = id
        self.userID = userID
        self.token = token
    }

    public let id: UUID
    public let userID: UUID
    public let token: String
}
