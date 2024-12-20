//
//  ForumDetailViewController.swift
//  WithPeace
//
//  Created by Hemg on 4/11/24.
//

import UIKit

final class ForumDetailViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    var onPostUpdated: ((PostModel) -> Void)?
    var postModel: PostModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupNavigationBar()
        setupTableView()
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setupNavigationBar() {
        let moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didTapMoreButton))
        self.navigationItem.rightBarButtonItem = moreButton
    }
    
    @objc private func didTapMoreButton() {
//        if postModel.?? == ??? {
            presentMyPostActionSheet()
//        } else {
//            presentOtherPostActionSheet()
//        }
    }
    
    private func presentMyPostActionSheet() {
        guard let editImage = UIImage(systemName: "pencil"),
              let deleteImage = UIImage(systemName: "trash") else { return }
        
        let topActionContents = (editImage, "수정하기", {
//            if let postModel = self?.postModel {
//                let editVC = PostViewController()
//                self?.navigationController?.pushViewController(editVC, animated: true)
//            }
            print("수정")
        })
        
        let bottomActionContents = (deleteImage, "삭제하기", {
            print("삭제")
        })
        
        let action = CustomActionSheetViewController(top: topActionContents, bottom: bottomActionContents)
        action.presentAsActionSheet(from: self)
    }
    
    private func presentOtherPostActionSheet() {
        guard let reportImage = UIImage(systemName: "exclamationmark.bubble"),
              let hideImage = UIImage(systemName: "eye.slash") else { return }
        
        let topActionContents = (reportImage, "신고하기", {
            print("신고하기")
        })
        
        let bottomActionContents = (hideImage, "이 글 보이지 않게하기", {
            print("글 안보이기")
        })
        
        let action = CustomActionSheetViewController(top: topActionContents, bottom: bottomActionContents)
        action.presentAsActionSheet(from: self)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ForumDetailCell.self, forCellReuseIdentifier: "ForumDetailCell")
        tableView.rowHeight = UITableView.automaticDimension
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ForumDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForumDetailCell",
                                                       for: indexPath) as? ForumDetailCell else {
            return UITableViewCell()
        }
        
        if let postModel = self.postModel {
            cell.setupData(postModel: postModel)
        }
        return cell
    }
}
