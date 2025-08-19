//
//  CommonLoadingView.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.27.
//

import SnapKit
import NVActivityIndicatorView
import UIKit

class CommonLoadingView: UIView {
    static let shared = CommonLoadingView()

    let widthSize: CGFloat = 100
    let heightSize: CGFloat = 100
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0.0, y: 0.0, width: kScreenWidth, height: kScreenHeight)
        //isUserInteractionEnabled = true
        addSubview(mView)
        mView.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
            make.size.equalTo(CGSize(width: widthSize, height: heightSize))
        }
        mView.addSubview(loadView)
        loadView.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
            make.width.height.equalTo(60)
        }
    }

    func showLoading(_ view: UIView, offsetY: CGFloat? = nil) {
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        //frame = CGRect(x: view.frame.size.width / 2 - widthSize / 2, y: view.frame.size.height / 2 - heightSize / 2, width: widthSize, height: heightSize)
        loadView.startAnimating()
    }

    func dismissLoading() {
        loadView.stopAnimating()
        removeFromSuperview()
    }

    // MARK: - setter & getter

    lazy var mView: UIView = {
        let view = UIView()
        view.backgroundColor = .mask
        view.setViewCorner(radius: 8)
        return view
    }()

    lazy var loadView: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect.zero, type: .circleStrokeSpin, color: .theme)
        return view
    }()
}
