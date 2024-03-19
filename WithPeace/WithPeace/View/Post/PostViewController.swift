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
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
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
            photoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryViewCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: "DescriptionCell")
    }
}

extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 3 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",
                                                           for: indexPath) as? CategoryViewCell else { return UITableViewCell() }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell",
                                                           for: indexPath) as? TitleCell else { return UITableViewCell() }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell",
                                                           for: indexPath) as? DescriptionCell else { return UITableViewCell() }
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
    }
}

extension PostViewController {
    private func didTapBack() {
        customNavigationBarView.onBackButtonTapped = { [weak self] in
            self?.didTapBackButton()
        }
    }
    
    private func didTapComplete() {
        customNavigationBarView.onCompleteButtonTapped = { [weak self] in
            self?.didTapCompleteButton()
        }
    }
    
    private func didTapPhoto() {
        photoView.onPhotoButtonTapped = { [weak self] in
            self?.didTapPhotoButton()
        }
    }
    
    private func didTapCompleteButton() {
        // 버튼 동작
        print("게시글등록")
    }
    
    private func didTapBackButton() {
        print("뒤로")
        //        navigationController?.popViewController(animated: true)
        //        self.dismiss(animated: true)
    }
    
    private func didTapPhotoButton() {
        print("사진")
    }
}
