//
//  CategorySelectViewController.swift
//  WithPeace
//
//  Created by Hemg on 3/19/24.
//

import UIKit

final class CategorySelectViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "게시글의 주제를 선택해주세요."
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var categoryButtons: [UIButton] = []
    private let gridStackView = UIStackView()
    var onCategorySelected: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupTitleLabel()
        setupViews()
        setupGridStackView()
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -287)
        ])
    }
    
    private func setupViews() {
        let titles = ["자유", "정보", "질문", "생활", "취미", "경제"]
        let images = ["ic-cate-free", "ic-cate-info", "ic-cate-question",
                      "ic-cate-living", "ic-cate-hobby", "ic-cate-eco"]
        let selectedImages = ["ic-cate-free-select", "ic-cate-info-select", "ic-cate-question-select",
                              "ic-cate-living-select", "ic-cate-hobby-select", "ic-cate-eco-select"]
        
        for i in 0..<titles.count {
            let button = UIButton()
            button.setTitle(titles[i], for: .normal)
            button.setImage(UIImage(named: images[i]), for: .normal)
            button.setImage(UIImage(named: selectedImages[i]), for: .selected)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
            categoryButtons.append(button)
        }
    }
    
    private func setupGridStackView() {
        gridStackView.axis = .vertical
        gridStackView.distribution = .fillEqually
        gridStackView.alignment = .fill
        gridStackView.spacing = 17
        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let topRowStackView = UIStackView()
        topRowStackView.axis = .horizontal
        topRowStackView.distribution = .fillEqually
        topRowStackView.alignment = .fill
        topRowStackView.spacing = 10
        
        let bottomRowStackView = UIStackView()
        bottomRowStackView.axis = .horizontal
        bottomRowStackView.distribution = .fillEqually
        bottomRowStackView.alignment = .fill
        bottomRowStackView.spacing = 10
        
        for i in 0..<3 {
            topRowStackView.addArrangedSubview(categoryButtons[i])
            bottomRowStackView.addArrangedSubview(categoryButtons[i+3])
        }
        
        gridStackView.addArrangedSubview(topRowStackView)
        gridStackView.addArrangedSubview(bottomRowStackView)
        
        view.addSubview(gridStackView)
        NSLayoutConstraint.activate([
            gridStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            gridStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            gridStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            gridStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -42)
            
        ])
    }
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        if let categoryTitle = sender.title(for: .normal) {
            onCategorySelected?(categoryTitle)
        }
        
        dismiss(animated: true)
    }
}

//TODO: CustomModalView
final class CategorySelectTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

final class CustomPresentationController: UIPresentationController {
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
        frame = CGRect(x: 0, y: containerView.bounds.height - 332, width: containerView.bounds.width, height: 332)
        return frame
    }
}
