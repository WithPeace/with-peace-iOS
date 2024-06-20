//
//  BlankPageViewController.swift
//  CheongHa
//
//  Created by Dylan_Y on 6/20/24.
//

import UIKit

final class BlankPageViewController: UIViewController {
    
    private let topBackButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: Const.CustomIcon.ICBtnPostcreate.icSignBack), for: .normal)
        
        return button
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: Const.Logo.MainLogo.cheonghaMainLogo)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "함께 날아가기 위한 날개를 만드는 중이에요!"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.text = "기능이 곧 업데이트될 예정이에요."
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("이전 화면으로 돌아가기", for: .normal)
        button.tintColor = UIColor(named: Const.CustomColor.BrandColor2.mainPurple)
        button.setTitleColor(UIColor(named: Const.CustomColor.BrandColor2.mainPurple), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.frame = .init(x: 0, y: 0, width: 183, height: 40)
//        button.layer.bounds = .init(x: 0, y: 0, width: 183, height: 40)
        button.layer.borderColor = UIColor(named: Const.CustomColor.BrandColor2.mainPurple)?.cgColor
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureLayout()
        [topBackButton, backButton].forEach {
            $0.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        }
    }
    
    private func configureLayout() {
        let safe = view.safeAreaLayoutGuide
        
        view.addSubview(topBackButton)
        view.addSubview(contentView)
        
        [imageView, mainTitleLabel, bodyLabel, backButton].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topBackButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: 11),
            topBackButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 160),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            mainTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 24),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc
    func tapButton() {
        self.dismiss(animated: true)
    }
}
