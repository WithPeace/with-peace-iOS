//
//  ForumCategoryView.swift
//  WithPeace
//
//  Created by Hemg on 4/1/24.
//

import UIKit

final class ForumCategoryView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let highlightSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var separatorWidthConstraint: NSLayoutConstraint?
    private var separatorLeadingConstraint: NSLayoutConstraint?
    private var selectedButtonIndex: Int?
    var onCategorySelected: ((Category) -> Void)?
    var previouslySelectedCategory: String? {
        didSet {
            updateCategoryButtonsSelection()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupCategoryButton()
        setupSeparatorView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        self.backgroundColor = .systemBackground
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            self.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    private func setupCategoryButton() {
        for (index, category) in Category.allCases.enumerated() {
            let button = UIButton()
            button.setTitle(category.rawValue, for: .normal)
            button.setImage(UIImage(named: category.imageName), for: .normal)
            button.setImage(UIImage(named: category.selectedImageName), for: .selected)
            button.tag = index
            button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func setupSeparatorView() {
        self.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 2),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 2),
        ])
        
        self.addSubview(highlightSeparatorView)
        separatorWidthConstraint = highlightSeparatorView.widthAnchor.constraint(equalToConstant: 0)
        separatorLeadingConstraint = highlightSeparatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        NSLayoutConstraint.activate([
            highlightSeparatorView.topAnchor.constraint(equalTo: separatorView.topAnchor),
            separatorLeadingConstraint!,
            separatorWidthConstraint!,
            highlightSeparatorView.heightAnchor.constraint(equalTo: separatorView.heightAnchor),
        ])
    }
    
    @objc func categoryButtonTapped(_ sender: UIButton) {
        selectedButtonIndex = sender.tag
        updateSeparatorPosition(index: sender.tag)
        
        if let category = Category(rawValue: sender.title(for: .normal) ?? "") {
            onCategorySelected?(category)
        }
    }
    
    private func updateCategoryButtonsSelection() {
        for button in stackView.arrangedSubviews as? [UIButton] ?? [] {
            if let title = button.title(for: .normal),
               let category = Category(rawValue: title) {
                let isSelected = category.rawValue == previouslySelectedCategory
                button.isSelected = isSelected
            }
        }
    }
    
    private func updateSeparatorPosition(index: Int) {
        let button = stackView.arrangedSubviews[index]
        
        separatorLeadingConstraint?.constant = button.frame.minX + stackView.frame.minX
        separatorWidthConstraint?.constant = button.frame.width
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}
