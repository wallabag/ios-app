import SwiftUI

struct PasteBoardView: View {
    @EnvironmentObject var pasteBoardViewModel: PasteBoardViewModel

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "doc.on.clipboard")
            VStack {
                Text("New url in pasteboard detected")
                    .font(.headline)
                Text(pasteBoardViewModel.pasteBoardUrl)
                    .lineLimit(1)
                HStack {
                    Button(action: {
                        self.pasteBoardViewModel.addUrl()
                    }, label: {
                        Text("Add")
                    })
                    Button(action: {
                        self.pasteBoardViewModel.hide()
                    }, label: {
                        Text("Cancel")
                    })
                }
            }
        }
    }
}

struct PasteBoardView_Previews: PreviewProvider {
    static var publisher: PasteBoardViewModel = {
        let pub = PasteBoardViewModel()
        pub.pasteBoardUrl = "http://wallabag-with-a-long-url.org"
        return pub
    }()

    static var previews: some View {
        Group {
            PasteBoardView().previewLayout(.sizeThatFits).environmentObject(publisher)
            PasteBoardView().previewLayout(.fixed(width: 250, height: 60)).environmentObject(publisher)
        }
    }
}
