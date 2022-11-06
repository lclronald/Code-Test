//
//  PagingAssistant.swift
//  Code_Test
//
//  Created by Cheuk Long on 3/11/2022.
//

import Foundation
import PagingKit
import SnapKit
import RxSwift
import RxCocoa

enum PagingReloadType {
    case all
    case menu
    case content
}

class PagingAssistant {
    // paging instance
    private let pagingMenuVC = PagingMenuViewController.init()
    private let pagingContentVC = PagingContentViewController.init()
    private var pagingManualBeginIndex: Int?
    private var pagingBeginIndex: Int?
    
    // input
    private let pagingMenuView: UIView?
    private let pagingContentView: UIView?
    var dataSource: [PagingMenu]
    

    // Paging Title Menu setting
    private var PTM_menuTextColor: UIColor = .lightGray
    private var PTM_menuTextFont = UIFont.systemFont(ofSize: 20)
    private var PTM_menuBackgroundColor: UIColor = .clear
    private var PTM_focusTextColor: UIColor = .black
    private var PTM_focusTextFont = UIFont.systemFont(ofSize: 20)
    private var PTM_focusBackgroundColor: UIColor = .clear
    
    // normal setting
    var menuPadding: CGFloat = 20.0 * RelativeConstraint.ratio
    private let menuItemSpacingObs: BehaviorRelay<CGFloat> = .init(value: 0)
    var menuItemSpacing: CGFloat { get { return self.menuItemSpacingObs.value } set { self.menuItemSpacingObs.accept(newValue) } }
    var menuItemWidth: CGFloat? = nil
    private let menuAlignmentObs: BehaviorRelay<PagingMenuView.Alignment> = .init(value: .left)
    var menuAlignment: PagingMenuView.Alignment { get { return self.menuAlignmentObs.value } set { self.menuAlignmentObs.accept(newValue) } }
    
    // focus view setting
    private var focusIndicatorColor: UIColor = .red
    private let focusIndicatorHeightObs = BehaviorRelay<CGFloat?>.init(value: nil)
    var focusIndicatorHeight: CGFloat? { get { return self.focusIndicatorHeightObs.value } set { self.focusIndicatorHeightObs.accept(newValue) } }
    
    private let backgroundColorObs = BehaviorRelay<UIColor>.init(value: .white)
    var backgroundColor: UIColor { get { return self.backgroundColorObs.value } set { self.backgroundColorObs.accept(newValue) }}

    // RX
    private let disposeBag = DisposeBag.init()
    
    // property
    private var getUnderlineFocusView: PagingUnderlineFocusView? {
        get { return self.pagingMenuVC.focusView.subviews.first(where: { $0 is PagingUnderlineFocusView }) as? PagingUnderlineFocusView }
    }
    private var getUnderlineIndicator: UIView? { get { return self.getUnderlineFocusView?.underlineView } }
    private var getSelectedCell: PagingCell? { get { return self.pagingMenuVC.cellForItem(at: self.selectedIndex) as? PagingCell } }
    private let selectedIndexObs = BehaviorRelay<Int>.init(value: 0)
    var selectedIndex: Int { get { return selectedIndexObs.value } }
    var selectedMenu: PagingMenu { get { self.dataSource[safe: self.selectedIndex] ?? .init() } }
    
    init(sourceVC: UIViewController?, pagingView: UIView? = nil, contentView: UIView? = nil, dataSource: [PagingMenu]) {
        self.pagingMenuView = pagingView
        self.pagingContentView = contentView
        self.dataSource = dataSource
        self.setupPagingMenuViewController(sourceVC: sourceVC)
        self.setupPagingContentViewController(sourceVC: sourceVC)
        self.setupOtherRX()
    }
    
    private func setupPagingMenuViewController(sourceVC: UIViewController?) {
        if let pagingMenuView = self.pagingMenuView {
            self.addPagingFeatureOnView(sourceVC: sourceVC, targetVC: self.pagingMenuVC, container: pagingMenuView)
            self.pagingMenuVC.register(nib: UINib(nibName: PagingCell.className, bundle: nil), forCellWithReuseIdentifier: PagingCell.className)
            self.pagingMenuVC.registerFocusView(nib: UINib.init(nibName: PagingUnderlineFocusView.className, bundle: nil))
            
            self.pagingMenuVC.delegate = self
            self.pagingMenuVC.dataSource = self
        }
    }
    
    private func setupPagingContentViewController(sourceVC: UIViewController?) {
        if let pagingContentView = self.pagingContentView {
            self.addPagingFeatureOnView(sourceVC: sourceVC, targetVC: self.pagingContentVC, container: pagingContentView)
            
            self.pagingContentVC.delegate = self
            self.pagingContentVC.dataSource = self
            
            self.menuItemSpacingObs
                .distinctUntilChanged()
                .subscribe(onNext: { [unowned self] spacing in
                    self.pagingMenuVC.cellSpacing = spacing
                })
                .disposed(by: self.disposeBag)
            
            self.menuAlignmentObs
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] alignment in
                    guard let self = self else { return }
                    self.pagingMenuVC.cellAlignment = alignment
                })
                .disposed(by: self.disposeBag)
            
            self.focusIndicatorHeightObs
                .distinctUntilChanged()
                .subscribe(onNext: { [unowned self] height in
                    self.getUnderlineFocusView?.setUnderlineHeight(height: height)
                })
                .disposed(by: self.disposeBag)
            
            self.backgroundColorObs
                .distinctUntilChanged()
                .subscribe(onNext: { [unowned self] color in
                    self.pagingMenuVC.view.backgroundColor = color
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    private func addPagingFeatureOnView(sourceVC: UIViewController?, targetVC: UIViewController, container: UIView) {
        if let sourceVC = sourceVC {
            self.addVC(sourceVC: sourceVC, targetVC: targetVC, container: container)
        } else {
            self.addView(targetVC: targetVC, container: container)
        }
    }
    
    private func addVC(sourceVC: UIViewController?, targetVC: UIViewController, container: UIView) {
        guard let sourceVC = sourceVC else { return }
        sourceVC.addChild(targetVC)
        container.addSubview(targetVC.view)
        targetVC.didMove(toParent: sourceVC)
        targetVC.view.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    private func addView(targetVC: UIViewController, container: UIView) {
        container.addSubview(targetVC.view)
        targetVC.view.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    private func setupOtherRX() {
        self.selectedIndexObs
            .subscribe(onNext: { [unowned self] index in
                self.updateIndicator()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func updateIndicator() {
        if let underlineView = self.getUnderlineIndicator {
            underlineView.backgroundColor = self.focusIndicatorColor
        }
    }
    
    private func updateSelectedIndex(index: Int) {
        if self.selectedIndex != index { self.selectedIndexObs.accept(index) }
    }
}

extension PagingAssistant {
    func selectTab(index: Int, animated: Bool = true) {
        if self.selectedIndex == index || index >= self.dataSource.count { return }
        
        self.pagingMenuVC.scroll(index: index, animated: animated)
        self.pagingContentVC.scroll(to: index, animated: animated)
        self.updateSelectedIndex(index: index)
    }
    
    func setPagingMenuStyle(menuTextColor: UIColor? = nil, focusTextColor: UIColor? = nil,
                            menuTextFont: UIFont? = nil, focusTextFont: UIFont? = nil,
                            menuBackgroundColor: UIColor? = nil, focusBackgroundColor: UIColor? = nil) {
        if let c = menuTextColor { self.PTM_menuTextColor = c }
        if let c = focusTextColor { self.PTM_focusTextColor = c }
        
        if let f = menuTextFont { self.PTM_menuTextFont = f }
        if let f = focusTextFont { self.PTM_focusTextFont = f }
        
        if let c = menuBackgroundColor { self.PTM_menuBackgroundColor = c }
        if let c = focusBackgroundColor { self.PTM_focusBackgroundColor = c }
    }
    
    func setIndicator(color: UIColor? = nil) {
        if let c = color { self.focusIndicatorColor = c }
        self.updateIndicator()
    }
    
    func reloadData(reloadType: PagingReloadType = .all, newDS: [PagingMenu]? = nil, completion: (() -> Void)? = nil) {
        if let newDS = newDS { self.dataSource = newDS }
        
        DispatchQueue.main.async(execute: {
            switch reloadType {
            case .all:
                let gp = DispatchGroup.init()
                gp.enter()
                self.pagingMenuVC.reloadData(completionHandler: { _ in gp.leave() })
                gp.enter()
                self.pagingContentVC.reloadData(completion: { gp.leave() })
                
                gp.notify(queue: .main, execute: {
                    completion?()
                })
            case .menu:
                self.pagingMenuVC.reloadData(completionHandler: { _ in completion?() })
            case .content:
                self.pagingContentVC.reloadData(completion: completion)
            }
        })
    }
}

extension PagingAssistant: PagingMenuViewControllerDataSource, PagingMenuViewControllerDelegate  {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        self.dataSource.count
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let info = self.dataSource[index]
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: PagingCell.className, for: index) as? PagingCell
        cell?.setContent(text: info.title)
        cell?.updateStyle(textColor: self.PTM_menuTextColor,
                         focusColor: self.PTM_focusTextColor,
                         textFont: self.PTM_menuTextFont,
                         focusFont: self.PTM_focusTextFont,
                         normalBG: self.PTM_menuBackgroundColor,
                         focusBG: self.PTM_focusBackgroundColor)
        return cell!
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        let info = self.dataSource[index]
        let fontSize = (self.pagingMenuVC.currentFocusedIndex == index) ? self.PTM_focusTextFont : self.PTM_menuTextFont
        return info.title.getTextSize(font: fontSize, widthExtra: self.menuPadding).width
    }
    
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        self.pagingContentVC.scroll(to: page, animated: true)
    }
}

extension PagingAssistant: PagingContentViewControllerDataSource, PagingContentViewControllerDelegate {
    /* === PagingContentViewControllerDataSource === */
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        self.dataSource.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return self.dataSource[safe: index]?.vc ?? UIViewController.init()
    }
    
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        self.updateSelectedIndex(index: index)
        self.pagingMenuVC.scroll(index: index, percent: percent, animated: false)
    }
    
    func contentViewController(viewController: PagingContentViewController, willBeginManualScrollOn index: Int) {
        self.pagingManualBeginIndex = index
    }
    
    func contentViewController(viewController: PagingContentViewController, didEndManualScrollOn index: Int) {
        if let _ = self.pagingManualBeginIndex {
            self.pagingManualBeginIndex = nil
        }
    }
    
    func contentViewController(viewController: PagingContentViewController, willBeginPagingAt index: Int, animated: Bool) {
        self.pagingBeginIndex = index
    }
    
    func contentViewController(viewController: PagingContentViewController, didFinishPagingAt index: Int, animated: Bool) {
        if let _ = self.pagingBeginIndex {
            self.pagingBeginIndex = nil
        }
    }
}
