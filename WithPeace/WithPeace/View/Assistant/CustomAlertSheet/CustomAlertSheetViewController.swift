//
//  CustomAlertSheetViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/27/24.
//

import UIKit

final class CustomAlertViewController: UIViewController {
    
    private let isTitleUsing: Bool
    private var containerView: CustomAlertSheetView
    
    init(title: String? = nil,
         body: String,
         leftButtonTitle: String,
         leftButtonAction: @escaping (() -> Void),
         rightButtonTitle: String,
         rightButtonAction: @escaping (() -> Void))
    {
        isTitleUsing = title == nil ? false : true
        containerView = CustomAlertSheetView(title: title,
                                             body: body,
                                             leftButtonTitle: leftButtonTitle,
                                             rightButtonTitle: rightButtonTitle)
        super.init(nibName: nil, bundle: nil)
        
        containerView.leftAction = {
            leftButtonAction()
            self.dismiss(animated: true)
        }
        
        containerView.rightAction = {
            rightButtonAction()
            self.dismiss(animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        configureLayout()
    }
    
    private func configureLayout() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let height: CGFloat = CGFloat(isTitleUsing ? 183 : 146)
        let width: CGFloat = 327
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: height),
            containerView.widthAnchor.constraint(equalToConstant: width)
        ])
    }
}
