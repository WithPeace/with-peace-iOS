//
//  BaseBottomSheetViewController.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/30/24.
//

import UIKit
import PinLayout
import FlexLayout

class BaseBottomSheetViewController: UIViewController {
    
    let dimmedBackView = UIView()
    let bottomSheetView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var dimmedTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideBottomSheetAction))
        return tap
    }()
    
    let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [dimmedBackView, bottomSheetView].forEach { view.addSubview($0) }
        bottomSheetView.addSubview(containerView)
        
        dimmedBackView.backgroundColor = .clear
        bottomSheetView.backgroundColor = .white
        
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        dimmedBackView.pin.all()
        bottomSheetView.pin.left().right().bottom()
        containerView.pin.all()
        containerView.flex.layout()
    }
    
    /// 바텀 시트 내리기
    func hideBottomSheet() {
        containerView.removeFromSuperview()
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self else { return }
            dimmedBackView.backgroundColor = .clear
            bottomSheetView.pin.left().right().bottom().top(100%)
        }, completion: { [weak self] _ in
            guard let self else { return }
            print("끝남")
            dismiss(animated: false)
        })
    }
    
    @objc private func hideBottomSheetAction() {
        hideBottomSheet()
    }
}
