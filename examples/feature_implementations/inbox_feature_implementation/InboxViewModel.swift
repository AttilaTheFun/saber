import InboxServiceInterface
import Observation
import SwiftUI

@Observable
final class InboxViewModel {
    @ObservationIgnored private var inboxService: any InboxService

    init(inboxService: any InboxService) {
        self.inboxService = inboxService
    }

    var inboxItems: [InboxItem] = []

    func getInboxItems() async {
        self.inboxItems = await self.inboxService.getInboxItems()
    }
}
