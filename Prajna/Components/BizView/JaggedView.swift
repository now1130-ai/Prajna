//
//  JaggedView.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.20.
//

import SnapKit
import UIKit

/// 一个自定义视图,用于创建包含多个均匀分布圆点的锯齿状或波浪状界面元素
class JaggedView: UIView {
    /// 圆点的背景颜色
    private var bgColor: UIColor = .card
    /// 圆点数量
    private var number: Int = 0

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /// 自定义初始化方法
    /// - Parameters:
    ///   - frame: 视图的框架
    ///   - backgroundColor: 圆点的背景颜色
    ///   - count: 圆点的数量
    init(frame: CGRect, backgroundColor: UIColor, count: Int) {
        super.init(frame: frame)
        bgColor = backgroundColor
        number = count
        addSubview(collectView)
        collectView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }

    // MARK: - 懒加载属性

    /// 用于显示圆点的集合视图
    lazy var collectView: BaseCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0

        // 计算圆点之间的间距
        let remaindNum = frame.size.width - self.frame.size.height * CGFloat(number)
        let reNum = number - 1
        if number > 1 {
            layout.minimumInteritemSpacing = remaindNum / CGFloat(reNum)
        } else {
            layout.minimumInteritemSpacing = 0
        }

        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // 设置每个圆点的大小为视图的高度
        layout.itemSize = CGSize(width: self.frame.size.height, height: self.frame.size.height)

        let collect = BaseCollectionView.creat(layout: layout, delegate: self)
        collect.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "JaggedItem")
        return collect
    }()
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension JaggedView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return number
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JaggedItem", for: indexPath)
        cell.backgroundColor = bgColor
        // 设置圆点的圆角为高度的一半,使其呈现为圆形
        cell.setViewCorner(radius: frame.size.height / 2)
        return cell
    }
}
