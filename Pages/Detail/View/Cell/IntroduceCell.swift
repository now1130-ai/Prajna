//
//  IntroduceCell.swift
//  shopga
//
//  Created by gogo on 2025/8/1.
//

import Foundation

class IntroduceCell: BaseTableViewCell {
 
    var model: IntroduceModel? {
        didSet {
            guard model != nil else { return }
            image.image = model?.image
            brand.text = model?.brand
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(image)
        image.snp.makeConstraints { make in
            make.top.equalTo(kMargin)
            make.left.equalTo(sMargin)
            make.width.equalTo(75)
            make.height.equalTo(100)
            make.bottom.equalTo(-kMargin)
        }
        contentView.addSubview(brand)
        brand.snp.makeConstraints { make in
            make.top.equalTo(image).offset(22)
            make.left.equalTo(image.snp.right).offset(sMargin)
            make.right.equalTo(-sMargin)
        }
    }
    
    // MARK: - setter & getter
    lazy var image: UIImageView = {
        let img = UIImageView()
        img.setViewCorner(radius: 6)
        return img
    }()
    
    lazy var brand: BaseLabel = {
        let lab = BaseLabel.creat(font: .creat(type: .PSB, size: 16), textColor: .word1)
        return lab
    }()
}
