//
//  ToastMessageView.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/16/24.
//

import UIKit

final class ToastMessageView {
    
    private let superView: UIView
    
    init(superView: UIView) {
        self.superView = superView
    }
    
    /// WithPeace Standard ToastMessage
    /// - Parameters:
    ///     - message: 토스트 메세지 띄울 문구
    
    func presentStandardToastMessage(_ message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 24,
                                               y: superView.frame.size.height - (35+49),
                                               width: superView.frame.size.width - 48,
                                               height: 49))
        
        let duration: Double = 2
        let delay: Double = 2
        
        toastLabel.backgroundColor =  UIColor(named: Const.CustomColor.SystemColor.black)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.textAlignment = .left
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 4
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
