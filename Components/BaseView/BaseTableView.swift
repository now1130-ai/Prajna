//
//  BaseTableView.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.07.
//

import MJRefresh
import UIKit
import RxSwift
import RxCocoa

class BaseTableView: UITableView {
    private let disposeBag = DisposeBag()
    
    var onDidHeaderRefresh: (() -> Void)?
    var onDidFooterRefresh: (() -> Void)?

    class func creat(style: UITableView.Style, delegate: Any) -> BaseTableView {
        let tableview = BaseTableView(frame: CGRect.zero, style: style)
        tableview.backgroundColor = .clear
        tableview.delegate = delegate as? UITableViewDelegate
        tableview.dataSource = delegate as? UITableViewDataSource
        tableview.showsVerticalScrollIndicator = false
        tableview.showsHorizontalScrollIndicator = false
        tableview.rowHeight = UITableView.automaticDimension
        tableview.separatorStyle = .none
        tableview.sectionHeaderHeight = CGFLOAT_MIN
        tableview.sectionFooterHeight = CGFLOAT_MIN
        //tableview.tableHeaderView = nil
        //tableview.tableFooterView = nil
        if #available(iOS 11.0, *) { 
            tableview.contentInsetAdjustmentBehavior = .never
        } else {}
        if #available(iOS 15.0, *) {
            tableview.sectionHeaderTopPadding = 0
        } else {}
        tableview.setupI18nObserver()
        return tableview
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
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

    func endNoMoreData() {
        mj_header?.endRefreshing()
        mj_footer?.endRefreshingWithNoMoreData()
    }

    @objc func callbackForHeaderRefreshView() {
        onDidHeaderRefresh?()
    }

    @objc func callbackForFooterRefreshView() {
        onDidFooterRefresh?()
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

extension UITableView {
    func register<Cell: BaseTableViewCell>(_ cellType: Cell.Type) {
        let reuseIdentifier = String(describing: cellType)
        self.register(cellType, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func dequeueReusableCell<Cell: BaseTableViewCell>(for indexPath: IndexPath) -> Cell {
        let reuseIdentifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Unable to dequeue cell with identifier \(reuseIdentifier)")
        }
        return cell
    }
}
