//
//  HomeTabVC.swift
//  Code_Test
//
//  Created by Cheuk Long on 4/11/2022.
//

import UIKit

class HomeTabModel {
    var title: String
    var img: UIImage
    var selectedImg: UIImage
    var vc: UIViewController
    
    init(title: String, img: UIImage?, selectedImg: UIImage?, vc: UIViewController) {
        self.title = title
        self.img = (img ?? .init()).withRenderingMode(.alwaysOriginal)
        self.selectedImg = (selectedImg ?? .init()).withRenderingMode(.alwaysOriginal)
        self.vc = vc
    }
}

enum HomeSignatureCode {
    case albums
    case collection
}

struct HomeTabDataSource {
    var pos: Int
    var sigatureCode: HomeSignatureCode
    var ds: HomeTabModel
}

class HomeTabVC: UITabBarController {
    lazy var ds: [HomeTabDataSource] = [
        .init(pos: 0, sigatureCode: .albums, ds: .init(title: "Albums List", img: UIImage.init(named: "Album_icon_normal"), selectedImg: UIImage.init(named: "Album_icon_selected"), vc: AlbumsListVC.init())),
        .init(pos: 1, sigatureCode: .collection, ds: .init(title: "Collection", img: UIImage.init(named: "collection_normal"), selectedImg: UIImage.init(named: "collection_selected"), vc: CollectionPagingVC.init()))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupCommon()
        self.setupTabController()
    }
    
    private func setupCommon() {
        delegate = self
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
    }
    
    private func setupTabController() {
        var viewControllers: [UIViewController] = []
        ds.sort { $0.pos < $1.pos}
        ds.forEach { tabDs in
            tabDs.ds.vc.tabBarItem = .init(title: tabDs.ds.title, image: tabDs.ds.img, selectedImage: tabDs.ds.selectedImg)
            viewControllers.append(UINavigationController.init(rootViewController: tabDs.ds.vc))
        }
        
        self.viewControllers = viewControllers
    }
    
    
}

extension HomeTabVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // print("Should select viewController: \(viewController.title ?? "") ?")
        //viewController.tabBarItem.badgeValue = nil
        return true
    }
}

