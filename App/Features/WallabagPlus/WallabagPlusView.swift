import SwiftUI

struct WallabagPlusView: View {
    @State private var showSubscriptionView = false

    var body: some View {
        VStack(alignment: .leading) {
            GroupBox("What is wallabag Plus?") {
                Text("wallabag Plus offers premium features powered by AI")
                    .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
            }
            GroupBox("Is wallabag Plus available on my self-hosted instance?") {
                Text("No, wallabag Plus is a premium feature only available on your iOS devices.")
                    .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
                Text("wallabag Plus is not affiliated with any other service.")
                    .font(.footnote)
            }
            GroupBox("What is included with wallabag Plus?") {
                Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10) {
                    GridRow {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Generate synthesis")
                    }
                    GridRow {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Suggest tag from entry")
                    }
                }
                .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            GroupBox("Privacy") {
                Text("When you use wallabag Plus, your entry will be sent to [OpenAI](https://openai.com)")
                    .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
            }
            Spacer()

            Button(action: {
                showSubscriptionView = true
            }, label: {
                Text("Subscribe")
            })
            .buttonStyle(.borderedProminent)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .fullScreenCover(isPresented: $showSubscriptionView, content: {
            WallabagPlusSubscribeView()
        })
        .navigationTitle("wallabag Plus")
    }
}

#Preview {
    WallabagPlusView()
}
