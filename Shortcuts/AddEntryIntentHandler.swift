import Combine
import Foundation
import Intents
import WallabagKit

class AddEntryIntentHandler: NSObject, AddEntryIntentHandling {
    private var cancellable: AnyCancellable?

    func handle(intent: AddEntryIntent, completion: @escaping (AddEntryIntentResponse) -> Void) {
        if let url = intent.url {
            let kit = WallabagKit(host: WallabagUserDefaults.host)
            kit.clientId = WallabagUserDefaults.clientId
            kit.clientSecret = WallabagUserDefaults.clientSecret
            kit.username = WallabagUserDefaults.login
            kit.password = WallabagUserDefaults.password

            cancellable = kit.send(to: WallabagEntryEndpoint.add(url: url.absoluteString))
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { compl in
                    switch compl {
                    case .finished:
                        completion(.success(result: "Url was added"))
                    case .failure:
                        completion(.failure(error: "Unable to add url, check url or your wallabag configuration"))
                    }
                }, receiveValue: { (_: WallabagEntry) in

                })
        } else {
            completion(.failure(error: "Unable to add url"))
        }
    }

    func resolveUrl(for intent: AddEntryIntent, with completion: @escaping (INURLResolutionResult) -> Void) {
        if let url = intent.url {
            completion(.success(with: url))
        } else {
            completion(.unsupported())
        }
    }
}
