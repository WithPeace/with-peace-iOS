//
//  CategorySelectViewController.swift
//  WithPeace
//
//  Created by Hemg on 3/19/24.
//

import UIKit

enum Category: String, CaseIterable {
    case free = "자유"
    case information = "정보"
    case question = "질문"
    case life = "생활"
    case hobby = "취미"
    case economy = "경제"

    var imageName: String {
        switch self {
        case .free: return "ic-cate-free"
        case .information: return "ic-cate-info"
        case .question: return "ic-cate-question"
        case .life: return "ic-cate-living"
        case .hobby: return "ic-cate-hobby"
        case .economy: return "ic-cate-eco"
        }
    }

    var selectedImageName: String {
        return "\(self.imageName)-select"
    }
}

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
    var previouslySelectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupTitleLabel()
        setupViews()
        setupGridStackView()
        updateSelectedButtonState()
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
        Category.allCases.forEach { category in
            let button = UIButton()
            button.setTitle(category.rawValue, for: .normal)
            button.setImage(UIImage(named: category.imageName), for: .normal)
            button.setImage(UIImage(named: category.selectedImageName), for: .selected)
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
    
    private func updateSelectedButtonState() {
        if let selectedCategory = previouslySelectedCategory {
            for button in categoryButtons {
                if button.title(for: .normal) == selectedCategory {
                    button.isSelected = true
                    break
                }
            }
        }
    }
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal),
              let category = Category(rawValue: title) else { return }
        
        onCategorySelected?(category.rawValue)
        dismiss(animated: true)
    }
    
    deinit {
        print("CategorySelectViewController Deinit")
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
