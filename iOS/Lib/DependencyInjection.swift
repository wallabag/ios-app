import Factory
import Foundation
import SharedLib
import WallabagKit

extension Container {
    var appState: Factory<AppState> {
        Factory(self) {
            AppState()
        }.scope(.singleton)
    }

    var router: Factory<Router> {
        Factory(self) {
            Router()
        }.scope(.singleton)
    }

    var errorHandler: Factory<ErrorViewModel> {
        Factory(self) {
            ErrorViewModel()
        }.scope(.singleton)
    }

    var playerPublisher: Factory<PlayerPublisher> {
        Factory(self) {
            PlayerPublisher()
        }.scope(.singleton)
    }

    var appSync: Factory<AppSync> {
        Factory(self) {
            AppSync()
        }.scope(.singleton)
    }

    var wallabagSession: Factory<WallabagSession> {
        Factory(self) {
            WallabagSession()
        }.scope(.singleton)
    }

    var imageDownloader: Factory<ImageDownloader> {
        Factory(self) {
            ImageDownloader()
        }.scope(.singleton)
    }

    var coreDataSync: Factory<CoreDataSync> {
        Factory(self) {
            CoreDataSync()
        }.scope(.singleton)
    }

    var appSetting: Factory<AppSetting> {
        Factory(self) {
            AppSetting()
        }.scope(.singleton)
    }

    var coreData: Factory<CoreData> {
        Factory(self) {
            CoreData()
        }.scope(.singleton)
    }

    var wallabagKit: Factory<WallabagKit> {
        Factory(self) {
            let kit = WallabagKit(host: WallabagUserDefaults.host)
            kit.clientId = WallabagUserDefaults.clientId
            kit.clientSecret = WallabagUserDefaults.clientSecret
            kit.username = WallabagUserDefaults.login
            kit.password = WallabagUserDefaults.password
            kit.accessToken = WallabagUserDefaults.accessToken
            kit.refreshToken = WallabagUserDefaults.refreshToken

            return kit
        }.scope(.singleton)
    }
}
