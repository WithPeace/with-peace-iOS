//
//  CommunityRegistration.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/27/24.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift
import RxCocoa

final class CommunityRegistrationViewController: UIViewController {
    
    private let rootContainerView = UIView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 52
        
        tableView.register(PostTopicCell.self, forCellReuseIdentifier: PostTopicCell.identifier)
        tableView.register(PostTitleCell.self, forCellReuseIdentifier: PostTitleCell.identifier)
        tableView.register(PostContentCell.self, forCellReuseIdentifier: PostContentCell.identifier)
        tableView.register(PostImagesCell.self, forCellReuseIdentifier: PostImagesCell.identifier)
        
        tableView.separatorStyle = .none
        return tableView
    }()
    private var dataSource: UITableViewDiffableDataSource<CommunityRegistrationSection, CommunityRegistrationSectionItem>!
        
    private let bottomContainerView = CommunityRegistrationBottomContainerView()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(rootContainerView)
        
        rootContainerView.flex.direction(.column).define { flex in
            flex.addItem(tableView).grow(1)
            flex.addItem(bottomContainerView).width(100%).height(52)
        }
        
        cellRegistration()
        
        let sections: [CommunityRegistrationSection : [CommunityRegistrationSectionItem]] = [
            .topic: [.topic(data: .init(topicData: "dfsdfas"))],
            .title: [.title(data: .init(titleData: "sdfsdfsdf"))],
            .content: [.content(data: .init(contentData: "adfasdfs"))],
            .selectedImages: [.selectedImages(data: .init(selectedImagesData: ["324", "asdfasd", "asdfasdf", "adfasdf", "fasdfa"]))]
        ]
        apply(with: sections)
        
        bind()
        
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootContainerView.pin.all(view.pin.safeArea).marginHorizontal(24)
        rootContainerView.flex.layout()
    }
    
    private func configureNavigationBar() {
        let buttonImage = UIImage(resource: .icSignBack)
        let backButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        let titleLabel = UILabel()
        titleLabel.text = "글 쓰기"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        let navigationTitleLabel = UIBarButtonItem(customView: titleLabel)
        navigationTitleLabel.tintColor = .black
        navigationItem.leftBarButtonItems = [backButton, navigationTitleLabel]
        
        let completeButtonImage = UIImage(resource: .btnPostcreateDoneSelect).withRenderingMode(.alwaysOriginal)
        let completeButton = UIBarButtonItem(image: completeButtonImage, style: .plain, target: self, action: #selector(completeButtonTapped))
        navigationItem.rightBarButtonItem = completeButton
    }
    
    private func cellRegistration() {
        
        // TableView cell
        dataSource = UITableViewDiffableDataSource<CommunityRegistrationSection, CommunityRegistrationSectionItem>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let section = CommunityRegistrationSection(rawValue: indexPath.section) else { return nil }
            
            switch section {
            case .topic:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTopicCell.identifier, for: indexPath) as? PostTopicCell else { return nil }
                cell.selectionStyle = .none
                return cell
            case .title:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTitleCell.identifier, for: indexPath) as? PostTitleCell else { return nil }
                cell.selectionStyle = .none
                return cell
            case .content:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PostContentCell.identifier, for: indexPath) as? PostContentCell else { return nil }
                cell.selectionStyle = .none
                
                cell.textViewDidChange = { [weak self] in
                    guard let self else { return }
                                    
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
                return cell
            case .selectedImages:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PostImagesCell.identifier, for: indexPath) as? PostImagesCell  else { return nil }
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    private func apply(with sections: [CommunityRegistrationSection: [CommunityRegistrationSectionItem]]) {
        var snapshot = NSDiffableDataSourceSnapshot<CommunityRegistrationSection, CommunityRegistrationSectionItem>()
        snapshot.appendSections(CommunityRegistrationSection.allCases)
        sections.forEach {
            snapshot.appendItems($0.value, toSection: $0.key)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func bind() {
        tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                guard let sections = CommunityRegistrationSection(rawValue: indexPath.section) else { return }
                switch sections {
                case .topic:
                    let selectPostTopicVC = SelectPostTopicViewController()
                    selectPostTopicVC.modalPresentationStyle = .overFullScreen
                    owner.present(selectPostTopicVC, animated: false)
                default: return
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func backButtonTapped(_ leftBarButtonItem: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func completeButtonTapped(_ rightBarButtonItem: UIBarButtonItem) {
        print("완료 버튼 눌림")
        dismiss(animated: true)
    }
}
