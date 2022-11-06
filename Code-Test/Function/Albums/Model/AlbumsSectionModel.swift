//
//  AlbumsSectionModel.swift
//  Code_Test
//
//  Created by Cheuk Long on 5/11/2022.
//

import Foundation
import RxDataSources

struct AlbumsSectionModel: SectionModelType {
    let sectionHeader: String?
    var items: [AlbumsDetailModel]
    
    
    init(sectionHeader: String?, items: [AlbumsDetailModel]) {
        self.sectionHeader = sectionHeader
        self.items = items
    }
    
    init(original: AlbumsSectionModel, items: [AlbumsDetailModel]) {
        self = original
        self.items = items
    }
}
