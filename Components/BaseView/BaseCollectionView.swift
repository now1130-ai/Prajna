//
//  BaseCollectionView.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.13.
//

import MJRefresh
import UIKit
import RxSwift
import RxCocoa

class BaseCollectionView: UICollectionView {
    private let disposeBag = DisposeBag()
    
    class func creat(layout: UICollectionViewLayout, delegate: Any) -> BaseCollectionView {
        let collect = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collect.backgroundColor = .clear
        collect.bounces = false
        collect.delegate = delegate as? UICollectionViewDelegate
        collect.dataSource = delegate as? UICollectionViewDataSource
        collect.showsVerticalScrollIndicator = false
        collect.showsHorizontalScrollIndicator = false
        collect.contentInsetAdjustmentBehavior = .never
        return collect
    }

    var onDidHeaderRefresh: (() -> Void)?
    var onDidFooterRefresh: (() -> Void)?

    func creatRefreshHeaderView() {
        mj_header = refreshHeader
    }

    func creatRefreshFooterView() {
        mj_footer = refreshFooter
    }

    func removeRefreshHeaderView() {
        refreshHeader.removeFromSuperview()
    }

    func removeRefreshFooterView() {
        refreshFooter.removeFromSuperview()
    }

    func endDataRefresh() {
        mj_header?.endRefreshing()
        mj_footer?.endRefreshing()
    }

    @objc func callbackForHeaderRefreshView() {
        if onDidHeaderRefresh != nil { onDidHeaderRefresh!() }
    }

    @objc func callbackForFooterRefreshView() {
        if onDidFooterRefresh != nil { onDidFooterRefresh!() }
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupI18nObserver()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupI18nObserver()
    }
    
    private func setupI18nObserver() {
        NotificationCenter.default.rx.notification(.onI18nRefresh)
            .subscribe(onNext: { [weak self] _ in
                self?.updateI18nTexts()
            })
            .disposed(by: disposeBag)
        updateI18nTexts()
    }
    
    private func updateI18nTexts() {
        refreshHeader.setTitle("uu.Pull down to refresh".localized, for: .idle)
        refreshHeader.setTitle("uu.Release to refresh".localized, for: .pulling)
        refreshHeader.setTitle("uu.Loading...".localized, for: .refreshing)
        
        refreshFooter.setTitle("uu.Pull up to load more".localized, for: .idle)
        refreshFooter.setTitle("uu.Release to load more".localized, for: .pulling)
        refreshFooter.setTitle("uu.Loading...".localized, for: .refreshing)
        refreshFooter.setTitle("uu.No more data".localized, for: .noMoreData)
    }

    lazy var refreshHeader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(callbackForHeaderRefreshView))
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = false
        header.arrowView?.image = UIImage(named: "")
        return header
    }()

    lazy var refreshFooter: MJRefreshAutoNormalFooter = {
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(callbackForFooterRefreshView))
        return footer
    }()
}

extension UICollectionView {
    func register<Cell: UICollectionViewCell>(_ cellType: Cell.Type) {
        let reuseIdentifier = String(describing: cellType)
        self.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func dequeueReusableCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
        let reuseIdentifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Unable to dequeue cell with identifier \(reuseIdentifier)")
        }
        return cell
    }
}
