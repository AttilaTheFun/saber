
public struct User: Hashable, Codable {
    public init(id: UInt64, username: String) {
        self.id = id
        self.username = username
    }
    
    public let id: UInt64
    public let username: String
}
