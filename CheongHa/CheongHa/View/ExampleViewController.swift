//
//  ExampleViewController.swift
//  CheongHa
//
//  Created by Dylan_Y on 8/5/24.
//

import UIKit
import RxSwift

final class ExampleViewController: UIViewController {
    
    private let viewModel = ExampleViewModel()
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
        
        viewModel.refreshControll.bind { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }.disposed(by: disposeBag)
        
        viewModel.popModal.bind { _ in
            DispatchQueue.main.async {
                let alert = CustomAlertSheetViewController(body: "가입해서 더 많은 정보를 받아보세요!", 
                                                           leftButtonTitle: "취소",
                                                           leftButtonAction: {},
                                                           rightButtonTitle: "가입하기",
                                                           rightButtonAction: {
                                    guard let app = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                                    app.moveToDefaultLoginView()
                })
                alert.modalPresentationStyle = .overFullScreen
                alert.modalTransitionStyle = .crossDissolve
                self.present(alert, animated: true)
            }
        }.disposed(by: disposeBag)
    }
}

//MARK: objc Method
extension ExampleViewController {
    @objc func refreshAction() {
        viewModel.refreshAction.onNext(())
    }
    
    @objc
    func tapRightButton() {
        viewModel.tapActionToRegist.onNext(())
    }
}

//MARK: Configure View
extension ExampleViewController {
    
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

extension ExampleViewController {
    
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

extension ExampleViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            viewModel.fetchAdditional.onNext(())
        }
    }
}

extension ExampleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        
        //TODO: Hard coding 수정
        var image: UIImage? = UIImage()
        
        switch cellData.polyRlmCd {
        case "023010":
            image = UIImage(named: Const.Image.MainLogo.jobThumbnail)
        case "023020":
            image = UIImage(named: Const.Image.MainLogo.livingThumbnail)
        case "023030":
            image = UIImage(named: Const.Image.MainLogo.eduThumbnail)
        case "023040":
            image = UIImage(named: Const.Image.MainLogo.cultureThumbnail)
        case "023050":
            image = UIImage(named: Const.Image.MainLogo.participationThumbnail)
        default:
            image = UIImage(named: Const.Logo.MainLogo.cheonghaMainLogo)
        }
        
        if let image = image {
            cell.setImageView(image: image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.tapActionToRegist.onNext(())
    }
}
