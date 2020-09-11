//
//  MenuView.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/01/2020.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var router: Router
    @Binding var showMenu: Bool

    fileprivate let menus: [Menu] = [
        .init(title: "Entries", img: "tray.full", route: .entries),
        .init(title: "Add entry", img: "tray.and.arrow.down", route: .addEntry),
        .init(title: "About", img: "questionmark", route: .about),
        .init(title: "Tips", img: "heart", route: .tips),
    ]

    // swiftlint:disable multiple_closures_with_trailing_closure
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                self.header()
                ForEach(self.menus) { menu in
                    HStack {
                        Button(action: {
                            self.router.load(menu.route)
                            withAnimation {
                                self.showMenu = false
                            }
                        }) {
                            Image(systemName: menu.img)
                                .frame(width: 24)
                            Text(menu.title)
                        }.padding(.vertical, 4)
                    }
                    Divider()
                }
                Spacer()
                HStack {
                    Button(action: {
                        self.router.load(.bugReport)
                        withAnimation {
                            self.showMenu = false
                        }
                    }) {
                        Image(systemName: "ant").padding(.leading, 2)
                        Text("Bug report").padding(.leading, 2)
                    }.padding(.vertical, 4)
                }
                Divider()
                HStack {
                    Button(action: {
                        withAnimation {
                            self.showMenu = false
                        }
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }) {
                        Image(systemName: "gear")
                        Text("Setting")
                    }.padding(.vertical, 4)
                }
                Divider()
                HStack {
                    Button(action: {
                        self.appState.logout()
                        withAnimation {
                            self.showMenu = false
                        }
                    }) {
                        Image(systemName: "person").padding(.leading, 2)
                        Text("Logout").padding(.leading, 3)
                    }.foregroundColor(.red)
                }
            }
            .padding(.top, geometry.safeAreaInsets.top)
            .padding(.bottom, geometry.safeAreaInsets.bottom == 0 ? 25 : geometry.safeAreaInsets.bottom)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.systemBackground))
        }
    }

    func header() -> AnyView {
        if #available(iOS 14.0, *) {
            return AnyView(Text("Menu")
                .font(.title)
                .fontWeight(.black)
                .onTapGesture {
                    withAnimation {
                        self.showMenu = false
                    }
                }.padding(.top, 44))
        } else {
            return AnyView(Text("Menu")
                .font(.title)
                .fontWeight(.black)
                .onTapGesture {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            )
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showMenu: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
