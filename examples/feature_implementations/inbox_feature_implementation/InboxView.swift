import InboxServiceInterface
import Saber
import SwiftUI

@Injectable
public struct InboxView: View {
    @Inject private var inboxViewModel: InboxViewModel

    public var body: some View {
        List(self.inboxViewModel.inboxItems) { inboxItem in
            InboxItemView(title: inboxItem.title, subtitle: inboxItem.subtitle)
        }
        .task {
            await self.inboxViewModel.getInboxItems()
        }
    }
}

#if DEBUG

final class MockInboxService: InboxService {
    func getInboxItems() async -> [InboxItem] {
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

final class MockInboxViewModelUnownedDependencies: InboxViewModelUnownedDependencies {
    let inboxService: any InboxService = MockInboxService()
}

final class MockInboxViewDependencies: InboxViewDependencies {
    let inboxViewModel = InboxViewModel(dependencies: MockInboxViewModelUnownedDependencies())
}

#Preview {
    InboxView(dependencies: MockInboxViewDependencies())
}

#endif
