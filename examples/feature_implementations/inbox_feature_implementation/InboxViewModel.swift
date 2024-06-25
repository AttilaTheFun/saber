import InboxServiceInterface
import Saber
import SwiftUI

@MainActor
@Injectable
final class InboxViewModel: ObservableObject {
    @Inject var inboxService: any InboxService
    @Published var inboxItems: [InboxItem] = []
    private var task: Task<Void, Never>?

    func getInboxItems() {
        self.task?.cancel()
        self.task = Task {
            let inboxItems = await self.inboxService.getInboxItems()
            await self.update(inboxItems: inboxItems)
        }
    }

    private func update(inboxItems: [InboxItem]) async {
        self.inboxItems = inboxItems
    }
}
