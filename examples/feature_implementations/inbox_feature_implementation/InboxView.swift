import InboxServiceInterface
import Saber
import SwiftUI

@Injectable
struct InboxView: View {
    @Inject var inboxService: any InboxService
    private var viewModel: InboxViewModel

    init(arguments: Arguments, dependencies: any Dependencies) {
        self._arguments = arguments
        self._dependencies = dependencies
        self.viewModel = InboxViewModel(inboxService: dependencies.inboxService)
    }

    var body: some View {
        List(self.viewModel.inboxItems) { inboxItem in
            InboxItemView(title: inboxItem.title, subtitle: inboxItem.subtitle)
        }
        .task {
            await self.viewModel.getInboxItems()
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

final class MockInboxViewDependencies: InboxViewDependencies {
    let inboxService: any InboxService = MockInboxService()
}

#Preview {
    InboxView(dependencies: MockInboxViewDependencies())
}

#endif
