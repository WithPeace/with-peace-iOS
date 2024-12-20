//
//  YouthPolicyViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/14/24.
//

import UIKit
import RxSwift
import RxCocoa

final class YouthPolicyViewController: UIViewController {
    
    private let viewModel: YouthPolicyViewModel
    private let disposeBag = DisposeBag()
    private var youthDataSource = [YouthPolicy]()
    private var youthPolicies: [PolicyData] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width - 48
        layout.estimatedItemSize.width = screenWidth
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(YouthListCell.self,
                                forCellWithReuseIdentifier: YouthListCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        return refreshControl
    }()
    
    private let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - User Event Observables
    private let filterVCDismissedSignal = PublishRelay<Void>() // FilterVC가 Dismiss 되었단 완료 이벤트
    
    init(viewModel: YouthPolicyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureNavigationController()
        configureLayout()
        configureCollectionView()
        configureRefreshController()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: Const.Logo.MainLogo.cheonghaTextLogo)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        navigationItem.titleView = imageView
    }
    
    private func configureNavigationController() {
        self.navigationController?.navigationBar.standardAppearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Const.CustomIcon.ICController.icFilter),
                                                                              style: .done,
                                                                              target: self,
                                                                              action: #selector(tapRightButton))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: Const.CustomColor.BrandColor2.mainPurple)
    }
    
    private func bind() {
        
//        viewModel.youthData.bind { [weak self] youthPolicy in
//            self?.youthDataSource = youthPolicy
//            DispatchQueue.main.async {
//                self?.collectionView.reloadData()
//            }
//        }.disposed(by: disposeBag)
//        
//        viewModel.youthData.bind { [weak self] youthPolicy in
//            self?.youthDataSource = youthPolicy
//            DispatchQueue.main.async {
//                self?.collectionView.reloadData()
//            }
//        }.disposed(by: disposeBag)
        
        filterVCDismissedSignal.asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.viewModel.filterVCDismissedSignal.accept(())
            }
            .disposed(by: disposeBag)
        
        viewModel.indicatorViewControll.bind { [weak self] in
            DispatchQueue.main.async {
                self?.indicatorView.stopAnimating()
            }
        }.disposed(by: disposeBag)
        
        viewModel.youthPolicies.asDriver()
            .drive(with: self) { owner, youthPolicies in
                owner.youthPolicies = youthPolicies
                owner.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        viewModel.refreshControll.bind { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }.disposed(by: disposeBag)
        
//        viewModel.popModal.bind { [weak self] youthFilterData in
//                DispatchQueue.main.async {
//                    let viewController = YouthFilterViewController(filterData: youthFilterData)
//                    viewController.delegate = self
//                    
//                    self?.present(viewController, animated: true)
//                }
//            }
//            .disposed(by: disposeBag)
        
        viewModel.presentPolicyDetailVC.asDriver(onErrorJustReturn: nil)
            .drive(with: self) { owner, policyDetailData in
                guard let policyDetailData else { return }
                let youthDetailViewController = YouthDetailViewController(policyDetail: policyDetailData)
                owner.navigationController?.pushViewController(youthDetailViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        guard let rightBarButtonItem = navigationItem.rightBarButtonItem else { return }
        rightBarButtonItem.rx.tap
            .bind(with: self) { owner, _ in
                let filterVC = FilterViewController(
                    viewModel: FilterViewModel(
                        filterUsecase: FilterUsecase(
                            filterRepository: FilterRepository(
                                keychain: KeychainManager(), network:
                                    CleanNetworkManager()
                            )
                        ),
                        inMemoryUsecase: InMemoryUsecase(
                            inMemoryRepository: InMemoryRepository()
                        ),
                        isFromYouthPolicyScreen: true
                    )
                )
                filterVC.modalPresentationStyle = .overFullScreen
                owner.present(filterVC, animated: false)
                
                // TODO: - HomeVC에 대한 의존성 문제 해결하기, Coordinator 패턴으로 해결하기
                filterVC.filterVCDismissSignalRelay.asDriver(onErrorJustReturn: ())
                    .drive(with: self) { onwer, _ in
                        owner.filterVCDismissedSignal.accept(())
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

//MARK: objc Method
extension YouthPolicyViewController {
    @objc func refreshAction() {
        viewModel.refreshAction.onNext(())
    }
    
    @objc
    func tapRightButton() {
        viewModel.tapFilterButton.onNext(())
    }
}

//MARK: Configure View
extension YouthPolicyViewController {
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 셀 Top inset 변경
        collectionView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        
        collectionView.refreshControl = refreshControl
    }
    
    private func configureRefreshController() {
        refreshControl.addTarget(self, action: #selector(refreshAction) , for: .valueChanged)
    }
}

extension YouthPolicyViewController {
    
    private func configureLayout() {
        self.view.addSubview(collectionView)
//        self.view.addSubview(indicatorView)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safe.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
        ])
        
//        NSLayoutConstraint.activate([
//            indicatorView.topAnchor.constraint(equalTo: safe.topAnchor),
//            indicatorView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
//            indicatorView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
//            indicatorView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
//        ])
    }
}

extension YouthPolicyViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            viewModel.fetchAdditional.onNext(())
        }
    }
}

extension YouthPolicyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        youthDataSource.count
        youthPolicies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YouthListCell.identifier, 
                                                            for: indexPath) as? YouthListCell else {
            return UICollectionViewCell()
        }
        
//        let cellData = youthDataSource[indexPath.row]
        
//        cell.setTitleLabel(cellData.polyBizSjnm)
//        cell.setBodyLabel(cellData.polyItcnCn)
//        cell.setRegionLabel(cellData.region())
//        cell.setAgeLagel(cellData.ageInfo)
        
        let cellData = youthPolicies[indexPath.row]
        
        cell.setTitleLabel(cellData.title)
        cell.setBodyLabel(cellData.introduce)
        cell.setRegionLabel(cellData.region)
        cell.setAgeLagel(cellData.ageInfo)
        
        //TODO: Hard coding 수정
//        var image: UIImage? = UIImage()
//
//        switch cellData.polyRlmCd {
//        case "023010":
//            image = UIImage(named: Const.Image.MainLogo.jobThumbnail)
//        case "023020":
//            image = UIImage(named: Const.Image.MainLogo.livingThumbnail)
//        case "023030":
//            image = UIImage(named: Const.Image.MainLogo.eduThumbnail)
//        case "023040":
//            image = UIImage(named: Const.Image.MainLogo.cultureThumbnail)
//        case "023050":
//            image = UIImage(named: Const.Image.MainLogo.participationThumbnail)
//        default:
//            image = UIImage(named: Const.Logo.MainLogo.cheonghaMainLogo)
//        }
        
//        if let image = image {
//            cell.setImageView(image: image)
//        }
        let image = UIImage(resource: cellData.classification.policyImage)
        cell.setImageView(image: image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let youthDetailViewController = YouthDetailViewController(youthPolicy: youthDataSource[indexPath.row])
//        self.navigationController?.pushViewController(youthDetailViewController, animated: true)
        viewModel.itemTapped.onNext(youthPolicies[indexPath.row].id)
//        let youthDetailViewController = YouthDetailViewController(youthPolicy: youthPolicies[indexPath.row])
//        self.navigationController?.pushViewController(youthDetailViewController, animated: true)
    }
}

extension YouthPolicyViewController: YouthFilterDelegate {
    func didUpdateFilter(_ filter: YouthFilterData) {
        viewModel.changeFilter.onNext(filter)
    }
}
