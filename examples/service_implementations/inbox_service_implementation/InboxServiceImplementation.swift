import Saber
import InboxServiceInterface
import UIKit

@Injectable(dependencies: .unowned)
public final class InboxServiceImplementation: InboxService {
    public func getInboxItems() async -> [InboxItem] {
        let date = Date()
        return [
            InboxItem(
                id: "1",
                createdAt: date.addingTimeInterval(-1*60*60*2),
                title: "John Doe",
                subtitle: "Check out the new Inbox"
            ),
            InboxItem(
                id: "2",
                createdAt: date.addingTimeInterval(-1*60*60*48),
                title: "Other Person",
                subtitle: "This isn't spam"
            ),
        ]
    }
}
