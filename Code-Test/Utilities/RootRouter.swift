//
//  RootRouter.swift
//  Code_Test
//
//  Created by Cheuk Long on 5/11/2022.
//

import Foundation
import UIKit

class RootRouter: NSObject {
    static let shared = RootRouter()
    var homeVC: HomeTabVC?
    
    func startup(_ window: UIWindow) {
        self.homeVC = HomeTabVC.init()
        window.rootViewController = homeVC
        window.makeKeyAndVisible()
    }
    
    func switchTab(type: HomeSignatureCode) {
        guard let vc = self.homeVC,
              let index = self.homeVC?.ds.firstIndex(where: { $0.sigatureCode == type }),
              index < vc.ds.count
        else { return }
        vc.selectedIndex = index
    }
    
    func present(toViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let fromViewController = homeVC?.selectedViewController {
            topMostViewControllerOf(viewController: fromViewController).present(toViewController, animated: animated, completion: completion)
        }
    }
    
    func topMostViewControllerOf(viewController: UIViewController) -> UIViewController {
        var topMostViewController = viewController
        
        while let nextViewController = topMostViewController.presentedViewController {
            topMostViewController = nextViewController
        }
        
        return topMostViewController
    }
    
    func getCurrentTopVC(vc: UIViewController? = RootRouter.shared.homeVC) -> UIViewController? {
        if let nav = vc as? UINavigationController {
            return self.getCurrentTopVC(vc: nav.visibleViewController)
        } else if let tab = vc as? HomeTabVC, let selectedVC = tab.selectedViewController {
            return self.getCurrentTopVC(vc: selectedVC)
        } else if let presentedVC = vc?.presentedViewController {
            return self.getCurrentTopVC(vc: presentedVC)
        }
        return vc
    }
}
