//
//  BaseVC.swift
//  Code_Test
//
//  Created by Cheuk Long on 5/11/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import MJRefresh

class BaseVC: UIViewController {

    lazy var barHeight = (navigationController?.navigationBar.frame.size.height ?? 44)
    let disposeBag = DisposeBag.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    var mjHeader = MJRefreshNormalHeader()
    func setupMJHeader(mjHeader: MJRefreshNormalHeader? = nil, action: Selector) -> MJRefreshNormalHeader {
        let mjHeader = mjHeader ?? self.mjHeader
        mjHeader.lastUpdatedTimeLabel?.isHidden = true
        mjHeader.setRefreshingTarget(self, refreshingAction: action)
        mjHeader.setTitle("向下滑動", for: .idle)
        mjHeader.setTitle("更新中", for: .refreshing)
        setMJHeaderTheme(mjHeader: mjHeader)
        return mjHeader
    }
    
    func setMJHeaderTheme(mjHeader: MJRefreshNormalHeader? = nil) {
        let mjHeader = mjHeader ?? self.mjHeader
        mjHeader.activityIndicatorViewStyle = .gray
        mjHeader.stateLabel?.textColor = .black
    }
}

extension BaseVC {
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }
}
