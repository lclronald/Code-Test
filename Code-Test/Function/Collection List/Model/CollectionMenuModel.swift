//
//  CollectionMenuModel.swift
//  Code-Test
//
//  Created by Cheuk Long on 5/11/2022.
//

import Foundation
import Realm
import ObjectMapper
import RealmSwift

class CollectionMenuModel: BaseModel {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var order: Int = 0
    @objc dynamic var title: String = ""
    var albums = List<AlbumsDetailModel>()
    
    static let albums_PROPERTY_NAME = "albums"
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func createDefaultMenu() {
        let menu = CollectionMenuModel()
        menu.order = 0
        menu.title = "預設歌單"
        DBManager.sharedInstance.addData(menu)
    }
    
    func getAlbumsList() -> [AlbumsDetailModel] {
        return Array(self.albums)
    }
}
