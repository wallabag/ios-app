import SwiftUI

struct RefreshButton: View {
    @Environment(AppSync.self) var appSync: AppSync

    var body: some View {
        ZStack {
            if appSync.inProgress {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                Button(
                    action: appSync.requestSync,
                    label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                )
                .buttonStyle(.plain)
                .accessibilityLabel("Refresh")
                .accessibilityHint("Refres entries from server")
                .keyboardShortcut("r", modifiers: .command)
            }
        }
        .frame(width: 34, height: 34, alignment: .center)
    }
}

struct RefreshButton_Previews: PreviewProvider {
    static var previews: some View {
        RefreshButton().environment(AppSync())
    }
}
