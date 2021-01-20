import SwiftUI

struct PlayerView: View {
    @EnvironmentObject var playerPublisher: PlayerPublisher

    var body: some View {
        VStack {
            if playerPublisher.podcast != nil {
                playerPublisher.podcast.map { podcast in
                    VStack {
                        EntryPicture(url: podcast.picture).frame(width: 100, alignment: .center)
                        Text(podcast.title)
                        HStack {
                            Button(action: {
                                playerPublisher.togglePlaying()
                            }, label: {
                                Image(systemName: playerPublisher.isPlaying ? "pause.circle" : "play.circle")
                            }).font(.system(size: 30))
                            Button(action: {
                                playerPublisher.stop()
                            }, label: {
                                Image(systemName: "stop.circle")
                            }).font(.system(size: 30))
                        }
                    }.padding()
                }
            } else {
                VStack {
                    EntryPicture(url: nil).frame(width: 100, alignment: .center)
                    Text("Select one entry")
                    HStack {
                        Button(action: {}, label: {
                            Image(systemName: "play.circle")
                                .font(.system(size: 30))
                        }).disabled(true)
                    }
                }
            }
        }
        .frame(width: 200, height: 200, alignment: .center)
        .background(Color.white)
        .cornerRadius(6)
        .shadow(radius: 10)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
