//
//  TableView+Extension.swift
//  Code_Test
//
//  Created by Cheuk Long on 5/11/2022.
//

import Foundation
import UIKit
import RxDataSources

typealias RxTVSectionDS = RxTableViewSectionedReloadDataSource

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        self.register(.init(nibName: T.className, bundle: nil), forCellReuseIdentifier: T.className)
    }
}
