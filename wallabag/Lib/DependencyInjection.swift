//
//  DependencyInjection.swift
//  wallabag
//
//  Created by Marinel Maxime on 01/10/2020.
//

import Foundation
import Logging
import SwiftyLogger
import Swinject
import WallabagKit

final class DependencyInjection {
    static let container: Container = {
        let container = Container()
        container.register(ErrorViewModel.self) { _ in ErrorViewModel() }.inObjectScope(.container)
        container.register(WallabagKit.self, factory: { _ in
            let kit = WallabagKit(host: WallabagUserDefaults.host)
            kit.clientId = WallabagUserDefaults.clientId
            kit.clientSecret = WallabagUserDefaults.clientSecret
            kit.username = WallabagUserDefaults.login
            kit.password = WallabagUserDefaults.password
            kit.accessToken = WallabagUserDefaults.accessToken
            kit.refreshToken = WallabagUserDefaults.refreshToken

            return kit
        }).inObjectScope(.container)
        container.register(WallabagSession.self, factory: { _ in WallabagSession() }).inObjectScope(.container)
        container.register(AppSync.self, factory: { _ in AppSync() }).inObjectScope(.container)
        container.register(ArticlePlayer.self) { _ in ArticlePlayer() }.inObjectScope(.container)
        container.register(ImageDownloader.self, factory: { _ in ImageDownloader.shared }).inObjectScope(.container)
        container.register(AppState.self, factory: { _ in AppState() }).inObjectScope(.container)
        container.register(Router.self, factory: { _ in Router() }).inObjectScope(.container)
        container.register(PlayerPublisher.self, factory: { _ in PlayerPublisher() }).inObjectScope(.container)
        container.register(Logger.self, factory: { _ in
            Logger(label: "fr.district-web.wallabag")
        }).inObjectScope(.container)

        return container
    }()
}
