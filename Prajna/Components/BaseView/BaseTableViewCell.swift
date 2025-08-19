//
//  BaseTableViewCell.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.07.
//

import UIKit
import RxCocoa
import RxSwift

class BaseTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
    }
}
