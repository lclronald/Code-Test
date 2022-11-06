//
//  AFNetworkingManager.swift
//  Code_Test
//
//  Created by Cheuk Long on 4/11/2022.
//

import Foundation
import Alamofire
import ObjectMapper

class AFNetworkingManager {
    /* singleton */
    private static var instance: AFNetworkingManager?
    static func shared() -> AFNetworkingManager {
        if instance == nil {
            instance = AFNetworkingManager.init()
        }
        return instance!
    }
    
    func requestModel<T: BaseModel>(url: String, completion: @escaping ((T) -> Void))  {
        AF.request(url).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let value):
                guard let castingValue = value as? [String: Any] else { return }
                guard let model = Mapper<T>().map(JSON: castingValue) else { return }
                completion(model)
            case .failure(let error):
                print(error)
            }
        })
    }
}
