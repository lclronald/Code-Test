//
//  DBManager.swift
//  Code-Test
//
//  Created by Cheuk Long on 5/11/2022.
//

import Foundation
import Realm
import RealmSwift

class DBManager {
    static let sharedInstance = DBManager()
    
    var database: Realm
    
    private init() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
               
            },
            objectTypes: [
                AlbumsDetailModel.self,
                CollectionMenuModel.self
            ]
        )
        database = try! Realm(configuration: config)
    }
    
    /* get data From DB */
    func getDataFromDB<T: BaseModel>(type: T.Type, filter: String? = nil) -> Results<T> {
        var results: Results<T> = database.objects(type)
        
        // fiter
        if let filter = filter {
            results = results.filter(filter)
        }
        
        return results
    }
    
    /* add data to DB in Array / Type format */
    @discardableResult
    func addData(_ object: BaseModel) -> Bool {
        return self.addData(object, true)
    }
    
    @discardableResult
    func addData(_ object: BaseModel, _ manageable: Bool) -> Bool {
        var success = false
        try! database.write {
            database.add(manageable ? object : object.unmanagedCopy(), update: .all)
            success = true
        }
        return success
    }
    
    func updateDataToDB(data object: BaseModel, set value: Any?, for key: String) {
        try! database.write {
            object.setValue(value, forKey: key)
        }
    }
}
