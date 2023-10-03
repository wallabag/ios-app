import SwiftUI

struct RefreshButton: View {
    @EnvironmentObject var appSync: AppSync

    var body: some View {
        HStack {
            if appSync.inProgress {
                ProgressView(value: appSync.progress, total: 100)
                #if os(iOS)
                    .progressViewStyle(.linear)
                #else
                    .progressViewStyle(.circular)
                #endif
            } else {
                Button(
                    action: appSync.requestSync,
                    label: {
                        Image(systemName: "arrow.counterclockwise")
                            .frame(width: 34, height: 34, alignment: .center)
                    }
                )
                .buttonStyle(.plain)
                .accessibilityLabel("Refresh")
                .accessibilityHint("Refres entries from server")
                .keyboardShortcut("r", modifiers: .command)
            }
        }
    }
}

struct RefreshButton_Previews: PreviewProvider {
    static var previews: some View {
        RefreshButton().environmentObject(AppSync())
    }
}
