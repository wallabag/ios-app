//
//  WallabagSession.swift
//  wallabag
//
//  Created by Marinel Maxime on 13/10/2019.
//

import Combine
import CoreData
import Foundation

class WallabagSession: ObservableObject {
    enum State {
        case unknown
        case connecting
        case connected
        case error(reason: String)
        case offline
    }

    @Published var state: State = .unknown
    @Injector var kit: WallabagKit
    @CoreDataViewContext var coreDataContext: NSManagedObjectContext
    private var cancellable = Set<AnyCancellable>()

    func requestSession() {
        state = .connecting
        _ = kit.requestAuth(
            clientId: WallabagUserDefaults.clientId,
            clientSecret: WallabagUserDefaults.clientSecret,
            username: WallabagUserDefaults.login,
            password: WallabagUserDefaults.password
        ).sink(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                switch error {
                case let WallabagKitError.jsonError(jsonError):
                    self.state = .error(reason: jsonError.errorDescription)
                default:
                    self.state = .error(reason: "Unknow error")
                }
            }
        }, receiveValue: { token in
            WallabagUserDefaults.refreshToken = token.refreshToken
            WallabagUserDefaults.accessToken = token.accessToken
            self.kit.bearer = token.accessToken
            self.state = .connected
        })
    }

    func addEntry(url: String, completion: @escaping () -> Void) {
        kit.send(decodable: WallabagEntry.self, to: WallabagEntryEndpoint.add(url: url))
            .catch { _ in Empty<WallabagEntry, Never>() }
            .sink { [unowned self] wallabagEntry in
                let entry = Entry(context: self.coreDataContext)
                entry.hydrate(from: wallabagEntry)
                completion()
            }
            .store(in: &cancellable)
    }

    func update(_ entry: Entry, parameters: WallabagKit.Parameters) {
        _ = kit.send(decodable: WallabagEntry.self, to: WallabagEntryEndpoint.update(id: entry.id, parameters: parameters)).sink(receiveCompletion: { completion in Log(completion) }, receiveValue: { _ in })
    }

    func delete(entry: Entry) {
        _ = kit.send(decodable: WallabagEntry.self, to: WallabagEntryEndpoint.delete(id: entry.id)).sink(receiveCompletion: { completion in Log(completion) }, receiveValue: { _ in })
    }

    func add(tag: String, for entry: Entry) {
        _ = kit.send(decodable: WallabagEntry.self, to: WallabagEntryEndpoint.addTag(tag: tag, entry: entry.id)).sink(receiveCompletion: { completion in Log(completion) }, receiveValue: { value in Log(value) })
    }

    func delete(tag: Tag, for entry: Entry) {
        _ = kit.send(decodable: WallabagEntry.self, to: WallabagEntryEndpoint.deleteTag(tagId: tag.id, entry: entry.id)).sink(receiveCompletion: { completion in Log(completion) }, receiveValue: { _ in })
    }
}
