//
//  EditDeleteSheet.swift
//  WithPeace
//
//  Created by Hemg on 3/25/24.
//

import UIKit

final class EditDeleteActionSheetViewController: UIViewController {
    
    private let modifyImageView = UIImageView()
    private let modifyButton = UIButton()
    private let deleteImageView = UIImageView()
    private let deleteButton = UIButton()
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.addSubview(modifyImageView)
        view.addSubview(modifyButton)
        view.addSubview(separatorView)
        view.addSubview(deleteImageView)
        view.addSubview(deleteButton)

        modifyImageView.contentMode = .scaleToFill
        #warning("imageView Assets add")
        modifyImageView.image = UIImage(named: "ic-camera") // 이미지 에셋 추가하면 변경
        
        deleteImageView.contentMode = .scaleToFill
        deleteImageView.image = UIImage(named: "ic-camera") // 여기도 이미지 에셋 추가하면 변경
        
        modifyButton.setTitle("수정하기", for: .normal)
        modifyButton.setTitleColor(.black, for: .normal)
        modifyButton.contentHorizontalAlignment = .leading
        modifyButton.layer.cornerRadius = 5
        modifyButton.addTarget(self, action: #selector(didTapModifyAction), for: .touchUpInside)
        
        deleteButton.setTitle("삭제하기", for: .normal)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.contentHorizontalAlignment = .leading
        deleteButton.layer.cornerRadius = 5
        deleteButton.addTarget(self, action: #selector(didTapDeleteAction), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        modifyImageView.translatesAutoresizingMaskIntoConstraints = false
        modifyButton.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            modifyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 46),
            modifyImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            modifyImageView.heightAnchor.constraint(equalToConstant: 24),
            modifyImageView.widthAnchor.constraint(equalToConstant: 24),
            
            modifyButton.leadingAnchor.constraint(equalTo: modifyImageView.trailingAnchor, constant: 8),
            modifyButton.centerYAnchor.constraint(equalTo: modifyImageView.centerYAnchor),
            modifyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            modifyButton.heightAnchor.constraint(equalToConstant: 21),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            separatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            deleteImageView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            deleteImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            deleteImageView.heightAnchor.constraint(equalToConstant: 24),
            deleteImageView.widthAnchor.constraint(equalToConstant: 24),
            
            deleteButton.leadingAnchor.constraint(equalTo: deleteImageView.trailingAnchor, constant: 8),
            deleteButton.centerYAnchor.constraint(equalTo: deleteImageView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            deleteButton.heightAnchor.constraint(equalToConstant: 21)
        ])
    }
    
    @objc private func didTapModifyAction() {
        print("수정")
    }
    
    @objc private func didTapDeleteAction() {
        print("삭제")
    }
    
    //TODO: 이거 부르면됨
    func presentAsActionSheet(from parentViewController: UIViewController) {
        let transitioningDelegate = CustomActionSheetTransitioningDelegate()
        self.transitioningDelegate = transitioningDelegate
        self.modalPresentationStyle = .custom
        parentViewController.present(self, animated: true)
    }
}

//TODO: CustomModalView
final class CustomActionSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomActionSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

final class CustomActionSheetPresentationController: UIPresentationController {
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped)))
        
        return view
    }()
    
    @objc private func dimmingViewTapped(_ sender: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerView = containerView else { return }
        containerView.insertSubview(dimmingView, at: 0)
        
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 1
            }, completion: nil)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        var frame = containerView.bounds
        frame = CGRect(x: 0, y: containerView.bounds.height - 171, width: containerView.bounds.width, height: 171)
        return frame
    }
}
