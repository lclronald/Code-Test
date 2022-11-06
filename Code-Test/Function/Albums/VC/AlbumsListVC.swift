//
//  AlbumsListVC.swift
//  Code-Test
//
//  Created by Cheuk Long on 5/11/2022.
//

import UIKit
import RxSwift
import RxCocoa

class AlbumsListVC: BaseVC {
    /* IBOutlet */
    @IBOutlet weak var tv: UITableView!
    
    /* Property */
    let vm = AlbumsListVCVM.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCommon()
        self.setupRx()
        self.setupTv()
        
        self.vm.requestData()
    
        // Do any additional setup after loading the view.
    }
    
    private func setupCommon() {
        self.title = "Albums List"
    }
    private func setupTv() {
        self.tv.register(AlbummsCell.self)
        self.tv.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.tv.mj_header = self.setupMJHeader(action: #selector(self.refresh))
        
        self.vm.setupTvSource(tv: self.tv, vc: self)
    }
    
    @objc func refresh() {
        self.mjHeader.endRefreshing()
        self.vm.requestData()
    }
    
    private func setupRx() {
        self.tv.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self,
                      let model = self.vm.tvDs.value[safe: indexPath.section]?.items[safe: indexPath.row]
                else { return }
                AlbumsService.shared().addItemToCollection(item: model)
            })
            .disposed(by: self.disposeBag)
    }
}

extension AlbumsListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.vm.getHeaderHeight()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

