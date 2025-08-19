//
//  CommonNoDataCell.swift
//  UU Wallet
//
//  Created by Dev1 on 2024/4/22.
//

import SnapKit
import UIKit

/// 哪个vc的NoData case+VC即可定位到是那个VC 如 withdraw->withdrawVC
enum NoDataStyle {
    /// 订单中心
    case orderCenter
    /// 提现
    case withdraw
    /// 资产首页记录列表
    case assets
    /// 资产详情
    case assetsDetail
    /// 汇率提醒列表
    case setRateRemind
    /// 通用通知列表
    case notificationsCommon
    /// 系统通知列表
    case notificationsSystem
    /// 预付卡充值记录
    case cardDepositRecords
    /// 兑换选择地址
    case convertOtherAccount
    /// 预付卡记录列表
    case cardDetails
    /// 兑换确认页面-账号列表为空
    case convertConfirmOfOrder
    /// 充值渠道
    case rechargeMethod
    /// 提现渠道
    case withdrawMethod
    /// 选择货币
    case chooseCurrency
    /// 选择线下商家
    case chooseCounter
    /// 此处没有线下商家
    case notCounter
}

class CommonNoDataCell: BaseTableViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(bgV)
        bgV.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.bottom.equalTo(contentView)
        }

        bgV.addSubview(imageV)
        imageV.snp.makeConstraints { make in
            make.centerX.equalTo(bgV)
            make.centerY.equalTo(bgV)
            make.top.equalTo(150)
            make.bottom.equalTo(-320)
        }

        bgV.addSubview(tipTopLb)
        tipTopLb.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(imageV.snp.bottom).offset(20)
        }

        bgV.addSubview(tipBottomLb)
        tipBottomLb.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(tipTopLb.snp.bottom).offset(4)
        }
    }

    var noDataStyle: NoDataStyle? {
        didSet {
            switch noDataStyle {
            case .orderCenter:
                imageV.snp.remakeConstraints { make in
                    make.centerX.equalTo(bgV)
                    make.centerY.equalTo(bgV)
                    make.top.equalTo(150)
                    make.bottom.equalTo(-320)
                }

            case .withdraw:
                tipTopLb.text = "uu.No record yet".localized
                tipBottomLb.text = ""
                imageV.snp.remakeConstraints { make in
                    make.centerX.equalTo(bgV)
                    make.centerY.equalTo(bgV)
                    make.top.equalTo(80)
                    make.bottom.equalTo(-190)
                }
            case .chooseCounter:
                tipTopLb.text = "offline/emptyConters".localized
                tipBottomLb.text = ""
                imageV.snp.remakeConstraints { make in
                    make.centerX.equalTo(bgV)
                    make.centerY.equalTo(bgV)
                    make.top.equalTo(80)
                    make.bottom.equalTo(-190)
                }
            case .notCounter:
                tipTopLb.text = "offline/noConters".localized
                tipBottomLb.text = ""
                imageV.isHidden = true
                imageV.snp.remakeConstraints { make in
                    make.centerX.equalTo(bgV)
                    make.centerY.equalTo(bgV)
                    make.top.equalTo(10)
                    make.bottom.equalTo(-20)
                }
            case .assets:
                imageV.snp.remakeConstraints { make in
                    make.centerX.equalTo(bgV)
                    make.centerY.equalTo(bgV)
                    make.top.equalTo(80)
                    make.bottom.equalTo(-190)
                }
            case .chooseCurrency:
                tipTopLb.text = "uu.No Currency".localized
                tipBottomLb.text = ""
                imageV.snp.remakeConstraints { make in
                    make.centerX.equalTo(bgV)
                    make.centerY.equalTo(bgV)
                    make.top.equalTo(80)
                    make.bottom.equalTo(-190)
                }
            case .assetsDetail:
                imageV.snp.remakeConstraints { make in
                    make.centerX.equalTo(bgV)
                    make.centerY.equalTo(bgV)
                    make.top.equalTo(60)
                    make.bottom.equalTo(-240)
                }

            case .setRateRemind:
                tipTopLb.text = "uu.You have no exchange rate".localized
                tipBottomLb.text = "uu.Please enter a exchange rate".localized
                imageV.snp.remakeConstraints { make in
                    make.centerX.equalTo(bgV)
                    make.centerY.equalTo(bgV)
                    make.top.equalTo(40)
                    make.bottom.equalTo(-108)
                }

            case .notificationsCommon:

                tipTopLb.text = "uu.No system notification yet".localized
                tipBottomLb.text = ""
                bgV.backgroundColor = .clear
                imageV.snp.remakeConstraints { make in
                    make.centerX.equalTo(bgV)
                    make.centerY.equalTo(bgV)
                    make.top.equalTo(159)
                    make.bottom.equalTo(-320)
                }

            case .notificationsSystem:

                tipTopLb.text = "uu.No system notification yet".localized
                tipBottomLb.text = ""
                bgV.backgroundColor = .card

                imageV.snp.remakeConstraints { make in
                    make.centerX.equalTo(bgV)
                    make.centerY.equalTo(bgV)
                    make.top.equalTo(150)
                    make.bottom.equalTo(-320)
                }

            case .cardDepositRecords:
                imageV.snp.remakeConstraints { make in
                    make.centerX.equalTo(bgV)
                    make.centerY.equalTo(bgV)
                    make.top.equalTo(150)
                    make.bottom.equalTo(-420)
                }

            case .convertOtherAccount:
                tipTopLb.text = "uu.No record yet".localized
                tipBottomLb.text = ""
                imageV.snp.remakeConstraints { make in
                    make.centerX.equalTo(bgV)
                    make.centerY.equalTo(bgV)
                    make.top.equalTo(80)
                    make.bottom.equalTo(-190)
                }

            case .cardDetails:
                imageV.snp.remakeConstraints { make in
                    make.centerX.equalTo(bgV)
                    make.centerY.equalTo(bgV)
                    make.top.equalTo(20)
                    make.bottom.equalTo(-100)
                }

            case .convertConfirmOfOrder:
                tipTopLb.text = "uu.You have no account data".localized
                tipBottomLb.text = "uu.Please add an account to".localized
                imageV.snp.remakeConstraints { make in
                    make.centerX.equalTo(bgV)
                    make.centerY.equalTo(bgV)
                    make.top.equalTo(40)
                    make.bottom.equalTo(-160)
                }

            case .rechargeMethod:
                bgV.setViewCorner(radius: 18)
                tipTopLb.text = "uu.No channel available".localized
                tipBottomLb.text = ""
                imageV.snp.remakeConstraints { make in
                    make.centerX.equalTo(bgV)
                    make.centerY.equalTo(bgV)
                    make.top.equalTo(140)
                    make.bottom.equalTo(-320)
                }

            default: break
            }
        }
    }

    // MARK: - getter & setter

    lazy var bgV: UIView = {
        let v = UIView()
        v.backgroundColor = .card
        return v
    }()

    lazy var imageV: UIImageView = {
        let v = UIImageView(image: UIImage(named: "ic_order_nodata"))
        return v
    }()

    lazy var tipTopLb: BaseLabel = {
        let v = BaseLabel.creat(font: .creat(type: .PM, size: 14), textColor: .word1, textAlignment: .center)
        v.text = "uu.You have no transaction record".localized
        return v
    }()

    lazy var tipBottomLb: BaseLabel = {
        let v = BaseLabel.creat(font: .creat(type: .PL, size: 12), textColor: .word2, textAlignment: .center)
        v.text = "uu.Please make a transaction".localized
        return v
    }()
}
