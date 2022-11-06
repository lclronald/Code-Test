//
//  AlbumsListVCVM.swift
//  Code_Test
//
//  Created by Cheuk Long on 5/11/2022.
//

import Foundation
import RxSwift
import RxCocoa

class AlbumsListVCVM {
    let tvDs: BehaviorRelay<[AlbumsSectionModel]> = .init(value: [])
    let disposeBag = DisposeBag.init()
    
    func setupTvSource(tv: UITableView, vc: UIViewController) {
        let rxDS = RxTVSectionDS<AlbumsSectionModel>.init(configureCell: { [weak self] ds, tv, indexPath, item in
            let cell = tv.dequeueReusableCell(withIdentifier: AlbummsCell.className, for: indexPath) as? AlbummsCell
            cell?.setContent(model: item)
            return cell!
        })

        self.tvDs
            .bind(to: tv.rx.items(dataSource: rxDS))
            .disposed(by: self.disposeBag)
    }
    
    func getHeaderHeight() -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

/* API */
extension AlbumsListVCVM {
    func requestData() {
        AlbumsService.shared().requestAlbums { model in
            self.tvDs.accept(model.results.compactMap({ return AlbumsSectionModel(sectionHeader: nil, items: [$0])}))
        }
    }
}
