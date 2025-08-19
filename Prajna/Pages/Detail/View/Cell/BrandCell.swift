//
//  BrandCell.swift
//  shopga
//
//  Created by gogo on 2025/8/1.
//

import Foundation

class BrandCell: BaseTableViewCell {
 
    var model: BrandModel? {
        didSet {
            guard model != nil else { return }
            brand.text = model?.brand
            modelLabel.text = model?.model
            review.text = model?.review
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.right.equalTo(-sMargin)
            make.size.equalTo(20)
        }
        
        
        contentView.addSubview(brand)
        brand.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.left.equalTo(sMargin)
            make.right.equalTo(arrow.snp.left).offset(8)
            make.height.equalTo(33)
        }
        
        contentView.addSubview(modelLabel)
        modelLabel.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.left.right.equalTo(arrow)
            make.height.equalTo(0)
        }
        
        contentView.addSubview(review)
        review.snp.makeConstraints { make in
            make.top.equalTo(brand.snp.bottom).offset(sMargin)
            make.left.equalTo(brand)
            make.right.equalTo(arrow)
            make.bottom.equalTo(-kMargin)
        }
        
    }
    
    // MARK: - setter & getter
    
    lazy var brand: BaseLabel = {
        let lab = BaseLabel.creat(font: .creat(type: .PSB, size: 24), textColor: .word1)
        return lab
    }()
    
    lazy var arrow: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "ic_brand_arrow")
        return img
    }()
    
    lazy var modelLabel: BaseLabel = {
        let lab = BaseLabel.creat(font: .creat(type: .PM, size: 14), textColor: .word2)
        return lab
    }()
    
    lazy var review: BaseLabel = {
        let lab = BaseLabel.creat(font: .creat(type: .PM, size: 16), textColor: .word2)
        return lab
    }()
}
