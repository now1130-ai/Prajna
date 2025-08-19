//
//  CommonTableViewSection.swift
//  UU Wallet
//
//  Created by Dev1 on 2024/3/27.
//

import SnapKit
import UIKit

class CommonTableViewSection: UIView {
    private var header: Bool = true

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(frame: CGRect, isHeader: Bool, margen: CGFloat? = nil, cornerRadius: CGFloat? = nil) {
        super.init(frame: frame)

        header = isHeader
        layer.masksToBounds = true
        addSubview(bgView)
        
        var currentMargen: CGFloat = kMargin
        
        if margen != nil {
            currentMargen = margen ?? kMargin
        }
        
        if isHeader {
            bgView.snp.makeConstraints { make in
                make.left.equalTo(currentMargen)
                make.right.equalTo(-currentMargen)
                make.top.equalTo(0)
                make.height.equalTo(36)
            }
        } else {
            bgView.snp.makeConstraints { make in
                make.left.equalTo(currentMargen)
                make.right.equalTo(-currentMargen)
                make.bottom.equalTo(0)
                make.height.equalTo(36)
            }
        }
        
        if cornerRadius == nil {
            bgView.setPartViewCorner(radius: 18, style: header ? .top : .bottom)
        } else {
            bgView.setPartViewCorner(radius: cornerRadius ?? 18.0, style: header ? .top : .bottom)
        }
    }

    // MARK: - getter & setter

    lazy var bgView: UIView = {
        let v = UIView()
        v.backgroundColor = .card
        return v
    }()
}
