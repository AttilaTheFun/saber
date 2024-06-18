
public struct InboxItem: Hashable {
    public let threadID: String
    public let title: String
    public let subtitle: String

    public init(threadID: String, title: String, subtitle: String) {
        self.threadID = threadID
        self.title = title
        self.subtitle = subtitle
    }
}

public protocol InboxService {
    func getInboxItems() async -> [InboxItem]
}
