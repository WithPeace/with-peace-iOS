//
//  HomeViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/14/24.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    private var youthDataSource = [YouthPolicy]()
    
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        ConfigureCollectionView()
        configureRefreshController()
        bind()
        
        //TODO: 추후 navigationViewController setting에 따른 네비게이션 수정
        // Navigation Appearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = .white
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Const.CustomIcon.ICController.icFilter),
                                                                              style: .done,
                                                                              target: self,
                                                                              action: #selector(tapRightButton))
        tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: Const.CustomColor.BrandColor2.mainPurple)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.navigationController?.isNavigationBarHidden = false
        
        //TODO: 추후 navigationViewController setting에 따른 네비게이션 수정
        //NaivgaitonItem View Setting
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: Const.Logo.MainLogo.chunghaMainLogo)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        tabBarController?.navigationItem.titleView = imageView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //NavigationItem View disappear
        tabBarController?.navigationItem.titleView = nil
    }
    
    private func bind() {
        viewModel.indicatorViewControll.bind { [weak self] in
            DispatchQueue.main.async {
                self?.indicatorView.stopAnimating()
            }
        }.disposed(by: disposeBag)
        
        viewModel.youthData.bind { [weak self] youthPolicy in
            self?.youthDataSource = youthPolicy
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }.disposed(by: disposeBag)
        
        viewModel.youthData.bind { [weak self] youthPolicy in
            self?.youthDataSource = youthPolicy
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }.disposed(by: disposeBag)
        
        viewModel.refreshControll.bind { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }.disposed(by: disposeBag)
    }
}

//MARK: objc Method
extension HomeViewController {
    @objc func refreshAction() {
        viewModel.refreshAction.onNext(())
    }
    
    @objc
    func tapRightButton() {
        //TODO: Navigation RightButton Action (filter데이터 추가)
        print("Tap RightButton")
        
        let vc = YouthFilterViewController()
//        vc.modalPresentationStyle = .overFullScreen
        
//        vc.modalTransitionStyle = .coverVertical
//        vc.modalPresentationCapturesStatusBarAppearance = .random()
        present(vc, animated: true)
        
        viewModel.changeFilter.onNext(FilteredData())
    }
}

//MARK: Configure View
extension HomeViewController {
    
    private func ConfigureCollectionView() {
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

extension HomeViewController {
    
    private func configureLayout() {
        self.view.addSubview(collectionView)
        self.view.addSubview(indicatorView)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safe.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: safe.topAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
        ])
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            viewModel.fetchAdditional.onNext(())
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        youthDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YouthListCell.identifier, 
                                                            for: indexPath) as? YouthListCell else {
            return UICollectionViewCell()
        }
        
        let cellData = youthDataSource[indexPath.row]
        
        cell.setTitleLabel(cellData.polyBizSjnm)
        cell.setBodyLabel(cellData.polyItcnCn)
        cell.setRegionLabel(cellData.region())
        cell.setAgeLagel(cellData.ageInfo)
        cell.setImageView(image: UIImage(named: Const.Logo.MainLogo.withpeaceLogo)!)
        
        return cell
    }
}
