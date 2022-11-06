//
//  AlbumsService.swift
//  Code_Test
//
//  Created by Cheuk Long on 5/11/2022.
//

import Foundation
import RealmSwift

class AlbumsService {
    /* singleton */
    private static var instance: AlbumsService?
    static func shared() -> AlbumsService {
        if instance == nil {
            instance = AlbumsService.init()
            instance?.setupDefault()
        }
        return instance!
    }
    
    private  func setupDefault() {
        if Array(DBManager.sharedInstance.getDataFromDB(type: CollectionMenuModel.self)).count < 1 { CollectionMenuModel.createDefaultMenu() }
    }
    
    func getAlbumMenu() -> [CollectionMenuModel] {
        var menu = Array(DBManager.sharedInstance.getDataFromDB(type: CollectionMenuModel.self))
        menu.sort { $0.order < $1.order }
        return menu
    }
    
    private func getNewAlbumOrder() -> Int {
        var menu = self.getAlbumMenu()
        menu.sort { $0.order > $1.order }
        return menu.first?.order ?? 0
    }
    
    func createNewCollection(title: String) {
        let nextOrder = self.getNewAlbumOrder() + 1
        let menu = CollectionMenuModel.init()
        menu.title = title
        menu.order = nextOrder
        DBManager.sharedInstance.addData(menu)
    }
    
    func addCollectionItem(model: CollectionMenuModel, item: AlbumsDetailModel) {
        let existingList = model.getAlbumsList()
        guard !existingList.map({ $0.collectionId }).contains(item.collectionId)
        else {
            Toast.show(message: "歌單已加入")
            return
        }
        let tmp = List<AlbumsDetailModel>()
        tmp.append(objectsIn: existingList)
        tmp.append(item)
        DBManager.sharedInstance.updateDataToDB(data: model, set: tmp, for: CollectionMenuModel.albums_PROPERTY_NAME)
        Toast.show(message: "成功加入歌單", cornerRadius: 10)
        
        let userInfo = ["ID": model.id]
        NotificationManager.post(type: .albumsDidAdd, userInfo: userInfo)
    }
    
    func addItemToCollection(item: AlbumsDetailModel) {
        let alert = UIAlertController(title: "選擇歌單", message: nil, preferredStyle: .actionSheet)
        
        self.getAlbumMenu().forEach { model in
            if !model.title.isEmpty {
                alert.addAction(UIAlertAction(title: model.title, style: .default , handler:{ (UIAlertAction)in
                    self.addCollectionItem(model: model, item: item)
                }))
            }
        }

        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
      
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view
        
        RootRouter.shared.present(toViewController: alert, animated: true, completion: nil)
    }
}

/* Network Related */
extension AlbumsService {
    func requestAlbums(completion: @escaping ((AlbumsModel) -> Void)) {
        AFNetworkingManager.shared().requestModel(url: API.requestAlbums) { (result: AlbumsModel) in completion(result) }
    }
}
