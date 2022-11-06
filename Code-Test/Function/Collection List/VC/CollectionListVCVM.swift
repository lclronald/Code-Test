//
//  CollectionListVCVM.swift
//  Code-Test
//
//  Created by Cheuk Long on 6/11/2022.
//

import Foundation
import RxSwift
import RxCocoa

class CollectionListVCVM: NSObject {
    let menuId: BehaviorRelay<String> = .init(value: "")
    let model: BehaviorRelay<[AlbumsDetailModel]> = .init(value: [])
    
    func requestUpdatedCollection() {
        self.menuId.accept(self.menuId.value)
    }
}
