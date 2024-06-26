import Foundation

public struct InboxItem: Hashable, Identifiable {
    public let id: String
    public let createdAt: Date
    public let title: String
    public let subtitle: String

    public init(
        id: String,
        createdAt: Date,
        title: String,
        subtitle: String)
    {
        self.id = id
        self.createdAt = createdAt
        self.title = title
        self.subtitle = subtitle
    }
}

public protocol InboxService {
    func getInboxItems() async -> [InboxItem]
}
