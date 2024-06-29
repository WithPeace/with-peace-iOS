//
//  ToastMessageView.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/16/24.
//

import UIKit

/// 해당 뷰에 Tabbar 있으면 true
final class ToastMessageView {
    
    private let superView: UIView
    private let hasTabbar: Bool
    
    init(superView: UIView, hasTabbar: Bool = false) {
        self.superView = superView
        self.hasTabbar = hasTabbar
    }
    
    /// CheongHa Standard ToastMessage
    /// - Parameters:
    ///     - message: 토스트 메세지 띄울 문구
    
    func presentStandardToastMessage(_ message : String) {
        var frameY: CGFloat = 35
        if hasTabbar {
            frameY += 85
        }
        
        let toastLabel = UILabel(frame: CGRect(x: 24,
                                               y: superView.frame.size.height - (frameY + 49),
                                               width: superView.frame.size.width - 48,
                                               height: 49))
        
        let duration: Double = 2
        let delay: Double = 2
        
        toastLabel.backgroundColor = UIColor(named: Const.CustomColor.SystemColor.black)
        toastLabel.textColor = UIColor.systemBackground
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.textAlignment = .left
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 4
        toastLabel.layer.borderWidth = 1
        toastLabel.layer.borderColor = UIColor.black.cgColor
        toastLabel.clipsToBounds  =  true
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 24
        let attributedText = NSAttributedString(string: message, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        toastLabel.attributedText = attributedText
        
        superView.addSubview(toastLabel)
        
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
