//
//  SyncOperation.swift
//  wallabag
//
//  Created by maxime marinel on 20/01/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation

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

    let articleSync: ArticleSync
    let page: Int
    let queue: DispatchQueue

    init(articleSync: ArticleSync, page: Int, queue: DispatchQueue) {
        self.articleSync = articleSync
        self.page = page
        self.queue = queue
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
            WallabagKit.instance.entry(parameters: ["page": page], queue: queue) { response in
                switch response {
                case .success(let collection):
                    self.articleSync.handle(result: collection.items)
                case .error:
                    //@todo handle error
                    break
                }
                self.state = .finished
            }
        }
    }
}
