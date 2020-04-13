//
//  Publishers.swift
//  wallabag
//
//  Created by Marinel Maxime on 13/04/2020.
//

import Combine
import Foundation

extension Publishers {
    class ScrollSubscription<S: Subscriber>: Subscription where S.Input == ((Int, Int), [WallabagEntry]), S.Failure == Error {
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
        }

        private func sendRequest(page: Int = 1) {
            _ = kit.send(decodable: WallabagCollection<WallabagEntry>.self, to: WallabagEntryEndpoint.get(page: page))
                .sink(receiveCompletion: { _ in }, receiveValue: { collection in
                    if collection.page < collection.pages {
                        self.sendRequest(page: collection.page + 1)
                    }
                    _ = self.subscriber?.receive(((collection.page, collection.pages), collection.items))
                    if collection.page == collection.pages {
                        self.subscriber?.receive(completion: .finished)
                    }
            })
        }
    }

    //swiftlint:disable nesting
    struct ScrollPublisher: Publisher {
        typealias Progress = (Int, Int)
        typealias Output = (Progress, [WallabagEntry])
        typealias Failure = Error

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
