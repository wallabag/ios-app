//
//  DBData.swift
//  wallabag
//
//  Created by Marinel Maxime on 11/07/2019.
//

import Combine
import RealmSwift
import SwiftUI

final class DBData: ObservableObject {
    let willChange = PassthroughSubject<DBData, Never>()

    private var notificationTokens: [NotificationToken] = []
    var results: Results<Entry>?

    init() {
        let realm = try! Realm()

        results = realm.objects(Entry.self)
        // Observe changes in the underlying model
        notificationTokens.append(results!.observe { _ in
            self.willChange.send(self)
        })
    }
}

class BindableResults<Element>: ObservableObject where Element: RealmSwift.RealmCollectionValue {
    let willChange = PassthroughSubject<Void, Never>()

    let results: Results<Element>
    private var token: NotificationToken!

    init(results: Results<Element>) {
        self.results = results
        lateInit()
    }

    func lateInit() {
        token = results.observe { _ in
            self.willChange.send(())
        }
    }

    deinit {
        token.invalidate()
    }
}
