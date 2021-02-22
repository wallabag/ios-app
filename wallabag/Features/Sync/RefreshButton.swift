import SwiftUI

struct RefreshButton: View {
    @EnvironmentObject var appSync: AppSync

    var body: some View {
        HStack {
            if appSync.inProgress {
                ProgressView(value: appSync.progress, total: 100)
            }

            Button(
                action: appSync.requestSync,
                label: {
                    Image(systemName: "arrow.counterclockwise")
                        .frame(width: 34, height: 34, alignment: .center)
                        .rotationEffect(.degrees(appSync.inProgress ? 0 : 360))
                }
            ).disabled(appSync.inProgress)
                .buttonStyle(PlainButtonStyle())
        }
    }
}

struct RefreshButton_Previews: PreviewProvider {
    static var previews: some View {
        RefreshButton().environmentObject(AppSync())
    }
}
