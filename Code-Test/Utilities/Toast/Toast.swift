//
//  Toast.swift
//  Code-Test
//
//  Created by Cheuk Long on 6/11/2022.
//

import Foundation
import UIKit
import SnapKit

class Toast {
    static func show(message: String, cornerRadius: CGFloat = 20) {
        guard let controller = RootRouter.shared.getCurrentTopVC() else { return }
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.roundCorner(radius: cornerRadius)

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = .appFont(ofSize: 17)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)

        toastLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(15)
            make.trailing.bottom.equalToSuperview().inset(15)
        }

        toastContainer.snp.makeConstraints { make in
            make.width.equalTo(message.getTextSize(font: .appFont(ofSize: 17), widthExtra: 35).width)
            make.centerY.centerX.equalToSuperview()
        }

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
