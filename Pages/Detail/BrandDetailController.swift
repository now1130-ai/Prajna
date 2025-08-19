//
//  DetailController.swift
//  shopga
//
//  Created by gogo on 2025/8/1.
//

import Foundation

class BrandDetailController: BaseVC {
    
    var image: UIImage?
    
    var introduce: IntroduceModel?
    var list: [BrandModel]?
    
    override func initVal() {
        super.initVal()
        introduce = IntroduceModel()
        introduce?.image = image
        
        list?.enumerated().forEach { index,item in
            if index < 2 {
                introduce?.brand += item.brand + "\n"
            }
        }
    }
    override func initView() {
        super.initView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.navView.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
        tableView.reloadData()
    }
    
    // MARK: - setter & getter
    
    lazy var tableView: BaseTableView = {
        let tab = BaseTableView.creat(style: .grouped, delegate: self)
        //tab.isHidden = true
        tab.register(IntroduceCell.self)
        tab.register(BrandCell.self)
//        tab.creatRefreshHeaderView()
//        tab.onDidHeaderRefresh = { [weak self] in
//            if self?.onDidRefresh != nil {
//                self?.onDidRefresh!()
//            }
//        }
        return tab
    }()
}

extension BrandDetailController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return list?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: IntroduceCell = tableView.dequeueReusableCell(for: indexPath)
            cell.model = introduce;
            return cell

        }else {
            let cell: BrandCell = tableView.dequeueReusableCell(for: indexPath)
            cell.model = list?[indexPath.row]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismissAnimated(animated: true) {}
    }
    
    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}
