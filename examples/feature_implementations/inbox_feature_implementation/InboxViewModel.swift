import InboxServiceInterface
import Observation
import Saber
import SwiftUI

@Observable
@Injectable(dependencies: .unowned)
public final class InboxViewModel {
    @Inject @ObservationIgnored private var inboxService: any InboxService

    public var inboxItems: [InboxItem] = []

    public func getInboxItems() async {
        self.inboxItems = await self.inboxService.getInboxItems()
    }
}
