//
//  ReportHideSheet.swift
//  WithPeace
//
//  Created by Hemg on 3/26/24.
//

import UIKit

final class ReportHideActionSheetViewController: UIViewController {
    
    private let reportImageView = UIImageView()
    private let reportButton = UIButton()
    private let hideImageView = UIImageView()
    private let hideButton = UIButton()
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
        view.addSubview(reportImageView)
        view.addSubview(reportButton)
        view.addSubview(separatorView)
        view.addSubview(hideImageView)
        view.addSubview(hideButton)
        
        reportImageView.contentMode = .scaleToFill
        #warning("imageView Assets add")
        reportImageView.image = UIImage(named: "ic-camera")
        
        hideImageView.contentMode = .scaleToFill
        hideImageView.image = UIImage(named: "ic-camera")
        
        reportButton.setTitle("신고하기", for: .normal)
        reportButton.setTitleColor(.black, for: .normal)
        reportButton.contentHorizontalAlignment = .leading
        reportButton.layer.cornerRadius = 5
        reportButton.addTarget(self, action: #selector(didTapModifyAction), for: .touchUpInside)
        
        hideButton.setTitle("이 사용자의 글 보지 않기", for: .normal)
        hideButton.setTitleColor(.black, for: .normal)
        hideButton.contentHorizontalAlignment = .leading
        hideButton.layer.cornerRadius = 5
        hideButton.addTarget(self, action: #selector(didTapDeleteAction), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        reportImageView.translatesAutoresizingMaskIntoConstraints = false
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        hideImageView.translatesAutoresizingMaskIntoConstraints = false
        hideButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            reportImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 46),
            reportImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            reportImageView.heightAnchor.constraint(equalToConstant: 24),
            reportImageView.widthAnchor.constraint(equalToConstant: 24),
            
            reportButton.leadingAnchor.constraint(equalTo: reportImageView.trailingAnchor, constant: 8),
            reportButton.centerYAnchor.constraint(equalTo: reportImageView.centerYAnchor),
            reportButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            reportButton.heightAnchor.constraint(equalToConstant: 21),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            separatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            hideImageView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            hideImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            hideImageView.heightAnchor.constraint(equalToConstant: 24),
            hideImageView.widthAnchor.constraint(equalToConstant: 24),
            
            hideButton.leadingAnchor.constraint(equalTo: hideImageView.trailingAnchor, constant: 8),
            hideButton.centerYAnchor.constraint(equalTo: hideImageView.centerYAnchor),
            hideButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            hideButton.heightAnchor.constraint(equalToConstant: 21)
        ])
    }
    
    @objc private func didTapModifyAction() {
        print("신고하기")
    }
    
    @objc private func didTapDeleteAction() {
        print("이 사용자의 글 보지 않기")
    }
    
    func presentAsActionSheet(from parentViewController: UIViewController) {
        let transitioningDelegate = CustomActionSheetTransitioningDelegate()
        self.transitioningDelegate = transitioningDelegate
        self.modalPresentationStyle = .custom
        parentViewController.present(self, animated: true)
    }
}
