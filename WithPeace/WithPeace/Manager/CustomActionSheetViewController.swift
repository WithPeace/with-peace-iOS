//
//  EditDeleteSheet.swift
//  WithPeace
//
//  Created by Hemg on 3/25/24.
//

import UIKit

final class CustomActionSheetViewController: UIViewController {
    
    private let topImageView = UIImageView()
    private let topButton = UIButton()
    private let bottomImageView = UIImageView()
    private let bottmButton = UIButton()
    
    private let topContents: (image: UIImage, label: String, action: () -> Void)
    private let bottomContents: (image: UIImage, label: String, action: () -> Void)
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    init(top: (UIImage, String, () -> Void), bottom: (UIImage, String, () -> Void)) {
        self.topContents = top
        self.bottomContents = bottom
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.addSubview(topImageView)
        view.addSubview(topButton)
        view.addSubview(separatorView)
        view.addSubview(bottomImageView)
        view.addSubview(bottmButton)
        
        topImageView.contentMode = .scaleToFill
        topImageView.image = topContents.image
        
        bottomImageView.contentMode = .scaleToFill
        bottomImageView.image = bottomContents.image
        
        topButton.setTitle(topContents.label, for: .normal)
        topButton.setTitleColor(.black, for: .normal)
        topButton.contentHorizontalAlignment = .leading
        topButton.layer.cornerRadius = 5
        topButton.addTarget(self, action: #selector(didTapTopAction), for: .touchUpInside)
        
        bottmButton.setTitle(bottomContents.label, for: .normal)
        bottmButton.setTitleColor(.black, for: .normal)
        bottmButton.contentHorizontalAlignment = .leading
        bottmButton.layer.cornerRadius = 5
        bottmButton.addTarget(self, action: #selector(didTapBottomAction), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        topButton.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        bottmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 46),
            topImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            topImageView.heightAnchor.constraint(equalToConstant: 24),
            topImageView.widthAnchor.constraint(equalToConstant: 24),
            
            topButton.leadingAnchor.constraint(equalTo: topImageView.trailingAnchor, constant: 8),
            topButton.centerYAnchor.constraint(equalTo: topImageView.centerYAnchor),
            topButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            topButton.heightAnchor.constraint(equalToConstant: 21),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            separatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            bottomImageView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            bottomImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            bottomImageView.heightAnchor.constraint(equalToConstant: 24),
            bottomImageView.widthAnchor.constraint(equalToConstant: 24),
            
            bottmButton.leadingAnchor.constraint(equalTo: bottomImageView.trailingAnchor, constant: 8),
            bottmButton.centerYAnchor.constraint(equalTo: bottomImageView.centerYAnchor),
            bottmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            bottmButton.heightAnchor.constraint(equalToConstant: 21)
        ])
    }
    
    @objc private func didTapTopAction() {
        topContents.action()
    }
    
    @objc private func didTapBottomAction() {
        bottomContents.action()
    }
    
    //TODO: 이거 부르면됨
    func presentAsActionSheet(from parentViewController: UIViewController) {
        let transitioningDelegate = CustomActionSheetTransitioningDelegate()
        self.transitioningDelegate = transitioningDelegate
        self.modalPresentationStyle = .custom
        parentViewController.present(self, animated: true)
    }
}
