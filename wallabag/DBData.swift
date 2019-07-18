//
//  DBData.swift
//  wallabag
//
//  Created by Marinel Maxime on 11/07/2019.
//

import Combine
import RealmSwift
import SwiftUI

final class DBData: BindableObject {
    let didChange = PassthroughSubject<DBData, Never>()

    private var notificationTokens: [NotificationToken] = []
    var results: Results<Entry>?

    init() {
        let realm = try! Realm()

        results = realm.objects(Entry.self)
        // Observe changes in the underlying model
        notificationTokens.append(results!.observe { _ in
            self.didChange.send(self)
        })
    }
}

class BindableResults<Element>: BindableObject where Element: RealmSwift.RealmCollectionValue {
    let didChange = PassthroughSubject<Void, Never>()

    let results: Results<Element>
    private var token: NotificationToken!

    init(results: Results<Element>) {
        self.results = results
        lateInit()
    }

    func lateInit() {
        token = results.observe { _ in
            self.didChange.send(())
        }
    }

    deinit {
        token.invalidate()
    }
}
