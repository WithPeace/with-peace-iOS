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
    var postDetailModel: PostDetailResponse?
    
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
    
    func setupData(postDetailModel: PostDetailResponse) {
        titleLabel.text = postDetailModel.data.title
        contentLabel.text = postDetailModel.data.content
        nickNametLabel.text = postDetailModel.data.nickname
        timeLabel.text = formatDate(postDetailModel.data.createDate)
        profileImage.loadImage(from: postDetailModel.data.profileImageUrl)
        
        imagesCollectionView.reloadData()
        updateCollectionViewHeight(imageUrls: postDetailModel.data.postImageUrls)
        print(postDetailModel.data.profileImageUrl)
        print("이제 포스트 이미지")
        print(postDetailModel.data.postImageUrls)
    }
    
    private func updateCollectionViewHeight(imageUrls: [String]) {
        let estimatedAspectRatio: CGFloat = 9 / 16
        let width = self.contentView.bounds.width
        let estimatedHeight = width * estimatedAspectRatio
        let totalHeight = estimatedHeight * CGFloat(imageUrls.count)
        imagesCollectionViewHeightConstraint?.constant = totalHeight
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return "날짜 파싱 실패"
    }
}

extension ForumDetailCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postDetailModel?.data.postImageUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageDetailCell", for: indexPath) as? ImageDetailCollectionViewCell,
              let urlString = postDetailModel?.data.postImageUrls[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        cell.loadImage(from: urlString)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let estimatedHeight = width * 9 / 16
        
        // 이미지 URL을 사용하여 비동기적으로 이미지 로드
        if let urlString = postDetailModel?.data.postImageUrls[indexPath.item],
           let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    let aspectRatio = image.size.height / image.size.width
                    let height = width * aspectRatio
                    DispatchQueue.main.async {
                        self?.imagesCollectionView.reloadData()
                    }
                }
            }.resume()
        }
        
        return CGSize(width: width, height: estimatedHeight)
    }
}

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            self.image = nil
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.image = nil
                }
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
