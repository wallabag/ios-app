import SharedLib
import SwiftUI

struct SettingView: View {
    @AppStorage("showImageInList") var showImageInList: Bool = true
    @AppStorage("justifyArticle") var justifyArticle: Bool = true
    @AppStorage("badge") var badge: Bool = true
    @AppStorage("defaultMode") var defaultMode: String = RetrieveMode.allArticles.rawValue
    @AppStorage("itemPerPageDuringSync") var itemPerPageDuringSync: Int = 50
    @AppStorage("refreshOnStartup") var refreshOnStartup: Bool = true

    var body: some View {
        Form {
            Section("Entries list") {
                Toggle("Show image in list", isOn: $showImageInList)
                Picker("Default mode", selection: $defaultMode) {
                    ForEach(RetrieveMode.allCases, id: \.rawValue) {
                        Text($0.rawValue).tag($0.settingCase)
                    }
                }
            }
            Section("Notifications") {
                Toggle("Show total entries badge", isOn: $badge)
            }
            Section("Entry") {
                Toggle("Justify entry", isOn: $justifyArticle)
            }
            Section("Sync") {
                Stepper("Items per page during sync: \(itemPerPageDuringSync)", value: $itemPerPageDuringSync, in: 20 ... 200)
                Toggle("Refresh on startup", isOn: $refreshOnStartup)
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
