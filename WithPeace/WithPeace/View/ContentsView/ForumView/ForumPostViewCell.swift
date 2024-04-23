//
//  ForumPostViewCell.swift
//  WithPeace
//
//  Created by Hemg on 3/28/24.
//

import UIKit

final class ForumPostViewCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        
        return label
    }()
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.setContentHuggingPriority(.init(rawValue: 500), for: .horizontal)
        
        return image
    }()
    private var titleLabelTrailingConstraintWithImage: NSLayoutConstraint?
    private var titleLabelTrailingConstraintWithoutImage: NSLayoutConstraint?
    private var contentLabelTrailingConstraintWithImage: NSLayoutConstraint?
    private var contentLabelTrailingConstraintWithoutImage: NSLayoutConstraint?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [titleLabel, contentLabel, imageView, timeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            timeLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -19),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        titleLabelTrailingConstraintWithImage = titleLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -9)
        titleLabelTrailingConstraintWithoutImage = titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        contentLabelTrailingConstraintWithImage = contentLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -9)
        contentLabelTrailingConstraintWithoutImage = contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    }
    
    func configure(postModel: PostModel) {
        titleLabel.text = postModel.title
        contentLabel.text = postModel.content
        
        if let imageData = postModel.imageFiles.first {
            let image = UIImage(data: imageData)
            imageView.image = image
            updateLayoutForImagePresence(isImagePresent: true)
        } else {
            imageView.image = nil
            updateLayoutForImagePresence(isImagePresent: false)
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        timeLabel.text = relativeTimeString(from: postModel.creationDate)
    }
    
    private func relativeTimeString(from postDate: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.second, .minute, .hour, .day, .weekOfYear], from: postDate, to: now)
        
        if let weeks = components.weekOfYear, weeks >= 1 {
            return "\(weeks)주 전"
        } else if let days = components.day, days >= 1 {
            return "\(days)일 전"
        } else if let hours = components.hour, hours >= 1 {
            return "\(hours)시간 전"
        } else if let minutes = components.minute, minutes >= 1 {
            return "\(minutes)분 전"
        } else if let seconds = components.second, seconds <= 20 {
            return "방금 전"
        } else if let seconds = components.second {
            return "\(seconds)초 전"
        } else {
            return "방금 전"
        }
    }
    
    private func updateLayoutForImagePresence(isImagePresent: Bool) {
        titleLabelTrailingConstraintWithImage?.isActive = isImagePresent
        titleLabelTrailingConstraintWithoutImage?.isActive = !isImagePresent
        contentLabelTrailingConstraintWithImage?.isActive = isImagePresent
        contentLabelTrailingConstraintWithoutImage?.isActive = !isImagePresent
        self.layoutIfNeeded()
    }
}
