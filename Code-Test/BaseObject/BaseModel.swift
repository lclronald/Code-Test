//
//  BaseModel.swift
//  Code_Test
//
//  Created by Cheuk Long on 5/11/2022.
//

import ObjectMapper
import RealmSwift

class BaseModel: Object, Mappable {
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
    }
    
    func unmanagedCopy() -> Self {
        let obj = type(of:self).init()
        for property in objectSchema.properties {
            let value = self.value(forKey: property.name)
            switch property.type {
            case .linkingObjects:
                break
            default:
                obj.setValue(value, forKey: property.name)
            }
        }
        
        return obj
    }
}
