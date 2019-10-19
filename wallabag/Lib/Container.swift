//
//  Container.swift
//  wallabag
//
//  Created by maxime marinel on 27/02/2019.
//

import Foundation
import RealmSwift
// import WallabagKit

// swiftlint:disable function_body_length
/* extension SwinjectStoryboard {
 private class func registerClass() {
     defaultContainer.register(AnalyticsManager.self) { _ in AnalyticsManager() }.inObjectScope(.container)
     defaultContainer.register(Realm.self) { _ in
         do {
             let config = Realm.Configuration(
                 schemaVersion: 8,
                 migrationBlock: { _, _ in
                 }
             )

             Realm.Configuration.defaultConfiguration = config
             Log("Realm path: \(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "")")
             return try Realm()
         } catch {
             fatalError("Error init realm")
         }
     }.inObjectScope(.container)
     defaultContainer.register(ThemeManager.self) { _ in
         ThemeManager(currentTheme: White())
     }.inObjectScope(.container)
     defaultContainer.register(WallabagSetting.self) { _ in WallabagSetting() }.inObjectScope(.container)
     defaultContainer.register(WallabagSession.self) { resolver in
         guard let setting = resolver.resolve(WallabagSetting.self) else { fatalError() }
         let session = WallabagSession(setting: setting)

         return session
     }.inObjectScope(.container)
     defaultContainer.register(ArticlePlayer.self) { resolver in
         let articlePlayer = ArticlePlayer()
         articlePlayer.analytics = resolver.resolve(AnalyticsManager.self)
         articlePlayer.setting = resolver.resolve(WallabagSetting.self)
         return articlePlayer
     }.inObjectScope(.container)
 }

 @objc class func setup() {
     registerClass()
 }
 } */
