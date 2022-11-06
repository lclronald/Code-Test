//
//  CollectionListVC.swift
//  Code-Test
//
//  Created by Cheuk Long on 5/11/2022.
//

import UIKit
import RxRelay

class CollectionListVC: BaseVC {

    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var addCollectionBtn: UIButton!
    
    let vm = CollectionListVCVM.init()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupRx()
        self.setupTv()
    }

    init(id: String) {
        self.vm.menuId.accept(id)
        super.init(nibName: CollectionListVC.className, bundle: nil)
        self.setupNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addCollectionBtn.titleLabel?.font = .appFont(ofSize: 20)
        self.addCollectionBtn.setTitle("新增唱片", for: .normal)
        self.addCollectionBtn.backgroundColor = .systemBlue
        self.addCollectionBtn.setTitleColor(.white, for: .normal)
        self.addCollectionBtn.roundCorner(radius: 10)
    }
    
    private func setupNotification() {
        NotificationManager.addObserver(self, selector: #selector(self.ablumsDidAdd(notification:)), type: .albumsDidAdd)
    }
    
    private func setupRx() {
        self.vm.menuId
            .subscribe(onNext: { [weak self] id in
                guard let self = self,
                      let collection = AlbumsService.shared().getAlbumMenu().first(where: { $0.id == id })?.getAlbumsList()
                else { return }
                self.vm.model.accept(collection)
            })
            .disposed(by: self.disposeBag)
            
        
        self.vm.model
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                let emptyCollection = model.count == 0
                self.tv.isHidden = emptyCollection
                self.addCollectionBtn.isHidden = !emptyCollection
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setupTv() {
        self.tv.register(AlbummsCell.self)
        
        self.vm.model
            .bind(to: self.tv.rx.items) { tv, row, model -> UITableViewCell in
                let cell = tv.dequeueReusableCell(withIdentifier: AlbummsCell.className, for: .init(row: row, section: 0)) as? AlbummsCell
                cell?.setContent(model: model)
                return cell!
            }
            .disposed(by: self.disposeBag)
    }
    
    @IBAction func addCollectionClick(_ sender: Any) {
        RootRouter.shared.switchTab(type: .albums)
    }
    
    @objc func ablumsDidAdd(notification: Notification) {
        guard let id = notification.userInfo?["ID"] as? String,
              id == self.vm.menuId.value
        else { return }
        self.vm.requestUpdatedCollection()
    }
}
