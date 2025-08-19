//
//  BaseHandyJSONModel.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.20.
//

import HandyJSON
import UIKit

class BaseHandyJSONModel: HandyJSON {
    required init() {}
    func mapping(mapper _: HelpingMapper) { // 自定义解析规则，日期数字颜色，如果要指定解析格式，子类实现重写此方法即可
    }
}
