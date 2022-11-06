//
//  NotificationManager.swift
//  Code-Test
//
//  Created by Cheuk Long on 6/11/2022.
//

import Foundation
import UIKit


class NotificationManager {
    enum NotiType: String {
        case didEnterBackground = "didEnterBackground"
        case didBecomeActive = "didBecomeActive"
        case willResignActive = "willResignActive"
        case albumsDidAdd = "albumsDidAdd"
    }
    
    class func post(type genre: NotiType, object anObject: Any? = nil, userInfo aUserInfo: [AnyHashable : Any]? = nil) {
        var aName: NSNotification.Name!
        
        switch genre {
        case .didEnterBackground:
            aName = UIApplication.didEnterBackgroundNotification
            
        case .didBecomeActive:
            aName = UIApplication.didBecomeActiveNotification
            
        case .willResignActive:
            aName = UIApplication.willResignActiveNotification
            
        default:
            aName = NSNotification.Name(rawValue: genre.rawValue)
        }
        
        NotificationCenter.default.post(name: aName, object: anObject, userInfo: aUserInfo)
    }
    
    class func addObserver(_ observer: Any, selector aSelector: Selector, type genre: NotiType? = nil, object anObject: Any? = nil) {
        var aName: NSNotification.Name?
        
        if let genre = genre {
            switch genre {
            case .didEnterBackground:
                aName = UIApplication.didEnterBackgroundNotification
                
            case .didBecomeActive:
                aName = UIApplication.didBecomeActiveNotification
                
            case .willResignActive:
                aName = UIApplication.willResignActiveNotification
                
            default:
                aName = NSNotification.Name(rawValue: genre.rawValue)
            }
            
        }
        
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: aName, object: anObject)
    }
    

}
