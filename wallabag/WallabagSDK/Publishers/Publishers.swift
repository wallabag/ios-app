//
//  Publishers.swift
//  wallabag
//
//  Created by Marinel Maxime on 13/04/2020.
//

import Combine
import Foundation

extension Publishers {
    class ScrollSubscription<S: Subscriber>: Subscription where S.Input == ((Int, Int), [WallabagEntry]), S.Failure == WallabagKitError {
        private var subscriber: S?
        private let kit: WallabagKit

        init(_ kit: WallabagKit, subscriber: S) {
            self.kit = kit
            self.subscriber = subscriber
            sendRequest()
        }

        func request(_: Subscribers.Demand) {}

        func cancel() {
            subscriber = nil
            // cancellable.forEach(cancel)
        }

        private var cancellable = Set<AnyCancellable>()

        private func sendRequest(page: Int = 1) {
            kit.send(to: WallabagEntryEndpoint.get(page: page))
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure:
                        self.subscriber?.receive(completion: completion)
                    case .finished:
                        break
                    }
                }, receiveValue: { (collection: WallabagCollection<WallabagEntry>) in
                    if collection.page < collection.pages {
                        self.sendRequest(page: collection.page + 1)
                    }
                    _ = self.subscriber?.receive(((collection.page, collection.pages), collection.items))
                    if collection.page == collection.pages {
                        self.subscriber?.receive(completion: .finished)
                    }
                }).store(in: &cancellable)
        }
    }

    // swiftlint:disable nesting
    struct ScrollPublisher: Publisher {
        typealias Progress = (Int, Int)
        typealias Output = (Progress, [WallabagEntry])
        typealias Failure = WallabagKitError

        private let kit: WallabagKit

        init(kit: WallabagKit) {
            self.kit = kit
        }

        func receive<S: Subscriber>(subscriber: S) where
            ScrollPublisher.Failure == S.Failure, ScrollPublisher.Output == S.Input {
            let subscription = ScrollSubscription(kit, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }
}
