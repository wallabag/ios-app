//
//  WallabagSession.swift
//  wallabag
//
//  Created by Marinel Maxime on 13/10/2019.
//

import Combine
import CoreData
import Foundation
import SwiftyLogger

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
        kit.clientId = WallabagUserDefaults.clientId
        kit.clientSecret = WallabagUserDefaults.clientSecret
        kit.username = WallabagUserDefaults.login
        kit.password = WallabagUserDefaults.password

        state = .connecting
        kit.requestToken()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    switch error {
                    case let WallabagKitError.jsonError(jsonError):
                        self.state = .error(reason: jsonError.errorDescription)
                    default:
                        self.state = .error(reason: "Unknow error")
                    }
                }
            }, receiveValue: { token in
                guard let token = token else { self.state = .unknown; return }
                WallabagUserDefaults.refreshToken = token.refreshToken
                WallabagUserDefaults.accessToken = token.accessToken
                self.kit.accessToken = token.accessToken
                self.kit.refreshToken = token.refreshToken
                self.state = .connected
        }).store(in: &cancellable)
    }

    func addEntry(url: String, completion: @escaping () -> Void) {
        kit.send(to: WallabagEntryEndpoint.add(url: url))
            .catch { _ in Empty<WallabagEntry, Never>() }
            .sink { [unowned self] (wallabagEntry: WallabagEntry) in
                let entry = Entry(context: self.coreDataContext)
                entry.hydrate(from: wallabagEntry)
                completion()
            }
            .store(in: &cancellable)
    }

    func update(_ entry: Entry, parameters: WallabagKit.Parameters) {
        kit.send(to: WallabagEntryEndpoint.update(id: entry.id, parameters: parameters)).sink(receiveCompletion: { completion in Log(completion) }, receiveValue: { (_: WallabagEntry) in })
        .store(in: &cancellable)
    }

    func delete(entry: Entry) {
        kit.send(to: WallabagEntryEndpoint.delete(id: entry.id)).sink(receiveCompletion: { completion in Log(completion) }, receiveValue: { (_: WallabagEntry) in })
        .store(in: &cancellable)
    }

    func add(tag: String, for entry: Entry) {
        kit.send(to: WallabagEntryEndpoint.addTag(tag: tag, entry: entry.id))
            .sink(receiveCompletion: { completion in Log(completion) }, receiveValue: { (wallabagEntry: WallabagEntry) in
                self.syncTag(for: entry, with: wallabagEntry)
            })
            .store(in: &cancellable)
    }

    func delete(tag: Tag, for entry: Entry) {
        kit.send(to: WallabagEntryEndpoint.deleteTag(tagId: tag.id, entry: entry.id)).sink(receiveCompletion: { completion in Log(completion) }, receiveValue: { (wallabagEntry: WallabagEntry) in
            self.syncTag(for: entry, with: wallabagEntry)
        })
            .store(in: &cancellable)
    }

    private func syncTag(for entry: Entry, with wallabagEntry: WallabagEntry) {
        entry.tags.removeAll()

        wallabagEntry.tags?.forEach { wallabagTag in
            if let tag = try? self.coreDataContext.fetch(Tag.fetchOneById(wallabagTag.id)).first {
                entry.tags.insert(tag)
            } else {
                let tag = Tag(context: self.coreDataContext)
                tag.id = wallabagTag.id
                tag.slug = wallabagTag.slug
                tag.label = wallabagTag.label
                entry.tags.insert(tag)
            }
        }
        try? coreDataContext.save()
    }
}
