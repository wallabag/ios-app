import SwiftUI

struct MenuView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.openURL) var openURL
    @EnvironmentObject var router: Router
    @Binding var showMenu: Bool

    fileprivate let menus: [Menu] = [
        .init(title: "Entries", img: "tray.full", route: .entries),
        .init(title: "Add entry", img: "tray.and.arrow.down", route: .addEntry),
        .init(title: "About", img: "questionmark", route: .about),
        .init(title: "Don", img: "heart", route: .tips),
        .init(title: "Setting", img: "gear", route: .setting),
    ]

    // swiftlint:disable multiple_closures_with_trailing_closure
    var body: some View {
        VStack(alignment: .leading) {
            header
            List {
                Section {
                    ForEach(self.menus) { menu in
                        Button(action: {
                            tapButtonMenu {
                                router.load(menu.route)
                            }
                        }) {
                            Label(menu.title, systemImage: menu.img)
                        }
                    }
                    Button(action: {
                        tapButtonMenu {
                            router.load(.bugReport)
                        }
                    }) {
                        Label("Bug report", systemImage: "ant")
                    }
                    Button(role: .destructive, action: {
                        tapButtonMenu {
                            self.appState.logout()
                        }
                    }) {
                        Label("Logout", systemImage: "person")
                    }.foregroundColor(.red)
                }
            }.listStyle(InsetListStyle())
        }
        .background(Color(UIColor.systemBackground))
    }

    private var header: some View {
        Text("Menu")
            .font(.title)
            .fontWeight(.black)
            .onTapGesture {
                withAnimation {
                    self.showMenu = false
                }
            }
            .padding(.top, 44)
            .padding(.horizontal)
    }

    private func tapButtonMenu(_ action: () -> Void) {
        withAnimation {
            showMenu = false
        }
        action()
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showMenu: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
