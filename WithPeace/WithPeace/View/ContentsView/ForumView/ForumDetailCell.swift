//
//  ForumDetailCell.swift
//  WithPeace
//
//  Created by Hemg on 4/11/24.
//

import UIKit

final class ForumDetailCell: UITableViewCell {
    private let categoryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Const.CustomIcon.ICBtnPostcreate.icSelect), for: .normal)
        
        return button
    }()
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 15
        
        return image
    }()
    private let nickNametLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10)
        
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    private var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        return layout
    }()
    private lazy var imagesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageDetailCollectionViewCell.self, forCellWithReuseIdentifier: "ImageDetailCell")
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private var imagesCollectionViewHeightConstraint: NSLayoutConstraint?
    var postModel: PostModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupLayout()
        setupcollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        
    }
    
    private func configureUI() {
        [categoryButton, profileImage, nickNametLabel, timeLabel]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview($0)
            }
        
        contentView.addSubview(stackView)
        contentView.addSubview(imagesCollectionView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
    }
    
    private func setupcollectionView() {
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        
        imagesCollectionView.setCollectionViewLayout(collectionViewLayout, animated: false)
        imagesCollectionViewHeightConstraint = imagesCollectionView.heightAnchor.constraint(equalTo: contentView.widthAnchor)
        imagesCollectionViewHeightConstraint?.isActive = true
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            categoryButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            categoryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            categoryButton.widthAnchor.constraint(equalToConstant: 80),
            categoryButton.heightAnchor.constraint(equalToConstant: 37),
            
            profileImage.heightAnchor.constraint(equalToConstant: 56),
            profileImage.widthAnchor.constraint(equalToConstant: 56),
            profileImage.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 16),
            profileImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            
            nickNametLabel.topAnchor.constraint(equalTo: profileImage.topAnchor),
            nickNametLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8),
            
            timeLabel.topAnchor.constraint(equalTo: nickNametLabel.bottomAnchor, constant: 7),
            timeLabel.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8),
            
            stackView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            imagesCollectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            imagesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        contentLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .vertical)
        contentLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .vertical)
        
    }
    
    func setupData(postModel: PostModel) {
        titleLabel.text = postModel.title
        contentLabel.text = postModel.content
        nickNametLabel.text = "닉네임 설정"
        timeLabel.text = formatDate(postModel.creationDate)
        //        if let profileImageData = postModel.profileImageData {
        profileImage.image = UIImage(systemName: "person.fill")
        //        }
        
        if let firstImageData = postModel.imageFiles.first,
           let firstImage = UIImage(data: firstImageData) {
            let aspectRatio = firstImage.size.height / firstImage.size.width
            let width = self.imagesCollectionView.frame.width
            let height = width * aspectRatio
            imagesCollectionViewHeightConstraint?.constant = height
        }
        
        self.postModel = postModel
        self.imagesCollectionView.reloadData()
        updateCollectionViewHeight(postModel: postModel)
    }
    
    private func updateCollectionViewHeight(postModel: PostModel) {
        var totalHeight: CGFloat = 0
        for imageData in postModel.imageFiles {
            if let image = UIImage(data: imageData) {
                let aspectRatio = image.size.height / image.size.width
                let width = self.contentView.bounds.width
                let height = width * aspectRatio
                totalHeight += height
            }
        }
        
        imagesCollectionViewHeightConstraint?.constant = totalHeight - self.imagesCollectionView.bounds.height
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

extension ForumDetailCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postModel?.imageFiles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageDetailCell", for: indexPath) as? ImageDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        DispatchQueue.main.async {
            if let imageData = self.postModel?.imageFiles[indexPath.item],
               let image = UIImage(data: imageData) {
                cell.configure(image: image)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let imageData = postModel?.imageFiles[indexPath.item],
              let image = UIImage(data: imageData) else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        
        let aspectRatio = image.size.height / image.size.width
        let width = collectionView.frame.width
        let height = width * aspectRatio
        return CGSize(width: width, height: height)
    }
}
