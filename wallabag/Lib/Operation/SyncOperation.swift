//
//  SyncOperation.swift
//  wallabag
//
//  Created by maxime marinel on 20/01/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation
import WallabagKit

final class SyncOperation: Operation {
    enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }

    override var isAsynchronous: Bool { return true }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }

    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }

    let entryController: EntryController
    let page: Int
    let queue: DispatchQueue
    let wallabagKit: WallabagKitProtocol

    init(entryController: EntryController, page: Int, queue: DispatchQueue, wallabagKit: WallabagKitProtocol) {
        self.entryController = entryController
        self.page = page
        self.queue = queue
        self.wallabagKit = wallabagKit
    }

    override func start() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .ready
            main()
        }
    }

    override func main() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .executing
            wallabagKit.entry(parameters: ["page": page], queue: queue) { response in
                switch response {
                case .success(let collection):
                    self.entryController.handle(result: collection.items)
                case .error:
                    //@todo handle error
                    break
                }
                self.state = .finished
            }
        }
    }
}
