import SwiftUI

struct InboxItemView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(self.title)
            Text(self.subtitle)
        }
    }
}

#Preview {
    InboxItemView(title: "John Doe", subtitle: "What's up?")
}
