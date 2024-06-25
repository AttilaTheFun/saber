import InboxServiceInterface
import Saber
import SwiftUI

//@Injectable
struct InboxView: View {
//    @StateObject
//    var viewModel: InboxViewModel
    let inboxItems = [
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

    var body: some View {
        List(self.inboxItems) { inboxItem in
            InboxItemView(title: inboxItem.title, subtitle: inboxItem.subtitle)
        }
    }
}

#if DEBUG

final class MockInboxService: InboxService {
    func getInboxItems() async -> [InboxItem] {
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

#endif

#Preview {
    InboxView()
}
