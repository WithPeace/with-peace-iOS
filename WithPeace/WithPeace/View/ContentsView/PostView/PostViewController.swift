//
//  PostViewController.swift
//  WithPeace
//
//  Created by Hemg on 3/18/24.
//

import UIKit
import RxSwift

final class PostViewController: UIViewController {
    private let customNavigationBarView = PostNavigationBarView()
    private let photoView = PostPhotoView()
    var viewModel = PostViewModel()
    let disposeBag = DisposeBag()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel.isCompleteButtonEnabled
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] isEnabled in
                self?.customNavigationBarView.updateCompleteButton(isEnabled: isEnabled)
            }
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        didTapBack()
        didTapComplete()
        didTapPhoto()
        setupCustomNaviBar()
        configureUI()
        setupTableView()
        setupPhotoView()
    }
    
    private func setupCustomNaviBar() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(customNavigationBarView)
        customNavigationBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavigationBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBarView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: customNavigationBarView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -82),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupPhotoView() {
        view.addSubview(photoView)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            photoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryViewCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: "DescriptionCell")
    }
    
    deinit {
        print("PostViewController Deinit")
    }
}

extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 3 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",
                                                           for: indexPath) as? CategoryViewCell else { return UITableViewCell() }
            
            viewModel.categorySelected
                .subscribe(onNext: { category in
                    let category = category ?? "카테고리의 주제를 선택하세요"
                    cell.configure(category)
                })
                .disposed(by: disposeBag)
            
            cell.onButtonTapped = { [weak self] in
                self?.showCategorySelectViewController()
                self?.tableView.reloadData()
            }
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell",
                                                           for: indexPath) as? TitleCell else { return UITableViewCell() }
            cell.textChanged
                .subscribe { [weak self] newTitle in
                    self?.viewModel.titleTextChanged.onNext(newTitle)
                }
                .disposed(by: disposeBag)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell",
                                                           for: indexPath) as? DescriptionCell else { return UITableViewCell() }
            cell.textChanged
                .subscribe { [weak self] newDescription in
                    self?.viewModel.contentTextChanged.onNext(newDescription)
                }
                .disposed(by: disposeBag)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension PostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 51
        case 1:
            return 53
        case 2:
            return 509
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            showCategorySelectViewController()
        }
    }
}

extension PostViewController {
    private func didTapBack() {
        customNavigationBarView.onBackButtonTapped = { [weak self] in
            self?.dismiss(animated: true)
            print("뒤로")
        }
    }
    
    private func didTapComplete() {
        customNavigationBarView.onCompleteButtonTapped = { [weak self] in
            self?.viewModel.updatePostModel()
            self?.dismiss(animated: true)
            print("게시글등록")
        }
    }
    
    private func didTapPhoto() {
        photoView.onPhotoButtonTapped = {
            let vc = CustomPhotoAlbumViewController(maxSelect: 5)
            vc.completionHandler = { [weak self] selectedImages in
                if let descriptionCell = self?.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? DescriptionCell {
                    for image in selectedImages {
                        self?.viewModel.selectImage(image)
                    }
                    descriptionCell.addImages(selectedImages)
                }
            }
            self.present(vc, animated: true)
            print("사진")
        }
    }
    
    private func showCategorySelectViewController() {
        let categorySelectVC = CategorySelectViewController()
        let transitioningDelegate = CategorySelectTransitioningDelegate()
        categorySelectVC.modalPresentationStyle = .custom
        categorySelectVC.transitioningDelegate = transitioningDelegate
        
        viewModel.categorySelected
            .subscribe { [weak categorySelectVC] category in
                categorySelectVC?.previouslySelectedCategory = category
            }
            .disposed(by: disposeBag)
        
        categorySelectVC.onCategorySelected = { [weak self] selectedCategory in
            self?.viewModel.categorySelected.onNext(selectedCategory)
            self?.tableView.reloadData()
        }
        
        self.present(categorySelectVC, animated: true)
    }
}
