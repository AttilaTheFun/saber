import Foundation

public struct User: Hashable, Codable {
    public init(id: UUID, username: String) {
        self.id = id
        self.username = username
    }
    
    public let id: UUID
    public let username: String
}
