import Factory
import SwiftUI

#if os(iOS)
    struct PlayerView: View {
        @EnvironmentObject var playerPublisher: PlayerPublisher

        var body: some View {
            VStack {
                if playerPublisher.podcast != nil {
                    playerPublisher.podcast.map { podcast in
                        VStack {
                            EntryPicture(url: podcast.picture).frame(width: 100, alignment: .center)
                            Text(podcast.title)
                                .padding(4)
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
                            }.buttonStyle(PlainButtonStyle())
                        }.padding()
                    }
                } else {
                    VStack {
                        EntryPicture(url: nil).frame(width: 100, alignment: .center)
                        Text("Select one entry")
                            .padding(4)
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
            .background(Color.primary.colorInvert())
            .cornerRadius(6)
            .shadow(radius: 10)
            .gesture(DragGesture().onEnded { swipe in
                if swipe.startLocation.x < swipe.location.x {
                    playerPublisher.showPlayer = false
                }
            })
        }
    }

    struct PlayerView_Previews: PreviewProvider {
        static var player: PlayerPublisher = {
            let coreData = Container.shared.coreData()
            let player = PlayerPublisher()
            let entry = Entry(context: coreData.viewContext)
            player.load(entry)
            return player
        }()

        static var previews: some View {
            PlayerView()
                .environmentObject(PlayerPublisher())
                .previewLayout(.sizeThatFits)

            PlayerView()
                .environmentObject(player)
                .previewLayout(.sizeThatFits)
        }
    }
#endif
