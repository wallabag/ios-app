//
//  SyncOperation.swift
//  wallabag
//
//  Created by maxime marinel on 20/01/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation

class SyncOperation: Operation {
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

    init(articleSync: ArticleSync, page: Int) {
        self.articleSync = articleSync
        self.page = page
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

            articleSync.wallabagApi?.entry(parameters: ["page": page]) { result in
                switch result {
                case .success(let collection):
                    self.articleSync.handle(result: collection.items)
                    self.state = .finished
                case .error:
                    self.state = .finished
                }
            }
        }
    }
}
