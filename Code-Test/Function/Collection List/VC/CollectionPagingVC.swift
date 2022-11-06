//
//  CollectionPagingVC.swift
//  Code-Test
//
//  Created by Cheuk Long on 5/11/2022.
//

import UIKit

class CollectionPagingVC: BaseVC {
    @IBOutlet weak var pagingView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var addCollection: UIButton!
    
    
    lazy var pagingAssistant = PagingAssistant(sourceVC: self, pagingView: self.pagingView, contentView: self.contentView, dataSource: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCommon()
        self.setupPaging()
    }
    
    private func setupCommon() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupPaging() {
        self.pagingAssistant.setIndicator(color: .black)
        self.pagingAssistant.menuItemSpacing = 10 * RelativeConstraint.ratio
        self.pagingAssistant.setPagingMenuStyle(menuTextColor: .color_aeaeae, focusTextColor: .black)
        self.setupPagingDataSource()
    }
    
    private func setupPagingDataSource() {
        let menu = AlbumsService.shared().getAlbumMenu()
        let pagingDs = menu.compactMap({  return PagingMenu.init(title: $0.title, vc: CollectionListVC.init(id: $0.id), customInfo: ["ID": $0.id])})
        self.pagingAssistant.reloadData(newDS: pagingDs)
    }
    
    @IBAction func addCollection(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a List", message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Input title.."
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add List", style: .default) { action in
            guard let title = textField.text else { return }
            AlbumsService.shared().createNewCollection(title: title)
            self.setupPagingDataSource()
        }
        
        alert.addAction(action)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

