import AppIntents
import SharedLib
import WallabagKit

protocol WallabagIntent: AppIntent {}

extension WallabagIntent {
    var kit: WallabagKit {
        let kit = WallabagKit(host: WallabagUserDefaults.host)
        kit.clientId = WallabagUserDefaults.clientId
        kit.clientSecret = WallabagUserDefaults.clientSecret
        kit.username = WallabagUserDefaults.login
        kit.password = WallabagUserDefaults.password
        return kit
    }
}
