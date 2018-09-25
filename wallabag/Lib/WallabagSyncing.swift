//
//  WallabagSyncing.swift
//  wallabag
//
//  Created by maxime marinel on 24/09/2018.
//

import Foundation
import WallabagKit

class WallabagSyncing {
    let kit: WallabagKitProtocol
    let dispatchQueue: DispatchQueue = .global()

    init(kit: WallabagKitProtocol) {
        self.kit = kit
    }

    func sync() {
        fetchEntry(page: 1)
    }

    func fetchEntry(page: Int) {
        Log("fetch \(page)")
        kit.entry(parameters: ["page": page], queue: dispatchQueue) { [unowned self] response in
            switch response {
            case .success(let entries):
                Log("success \(page)/\(entries.pages)")
                if page < entries.pages {
                    self.fetchEntry(page: page + 1)
                }
            case .error:
                Log("Fetch error")
            }
        }
    }
}
