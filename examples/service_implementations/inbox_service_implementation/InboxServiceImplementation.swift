import Saber
import InboxServiceInterface
import UIKit

@Injectable(dependencies: .unowned)
public final class InboxServiceImplementation: InboxService {
    public func getInboxItems() async -> [InboxItem] {
        return [
            InboxItem(
                id: "1",
                title: "John Doe",
                subtitle: "Check out the new Inbox"
            ),
            InboxItem(
                id: "2",
                title: "Other Person",
                subtitle: "This isn't spam"
            ),
        ]
    }
}
