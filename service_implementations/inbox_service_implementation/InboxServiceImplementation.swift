import DependencyFoundation
import DependencyMacros
import InboxServiceInterface
import UIKit

@Injectable(.unowned)
public final class InboxServiceImplementation: InboxService {
    public func getInboxItems() async -> [InboxItem] {
        return [
            InboxItem(
                threadID: "1",
                title: "Logan Shire",
                subtitle: "Check out the new Inbox"
            ),
            InboxItem(
                threadID: "2",
                title: "Other Person",
                subtitle: "This isn't spam"
            ),
        ]
    }
}
