//
//  HomeViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/14/24.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        // 셀 Top inset 변경
        collectionView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        
        // Navigation Appearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = .white
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        //NaivgaitonItem View Setting
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: Const.Logo.MainLogo.withpeaceLogo)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        tabBarController?.navigationItem.titleView = imageView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //NavigationItem View disappear
        tabBarController?.navigationItem.titleView = nil
    }
}

extension HomeViewController {
    
    private func configureLayout() {
        self.view.addSubview(collectionView)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safe.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
        ])
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YouthListCell.identifier, 
                                                            for: indexPath) as? YouthListCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.row % 2 == 1 {
            cell.setTitleLabel("청년창업 지원사업 예비 창업자 모집 안내")
            cell.setBodyLabel("생애 최초로 창업에 도전하는 만 29세 이하 청년 예비 창업자들의 성공을 위해 지원하는 정책이 나왔습니다")
            cell.setRegionLabel("서울")
            cell.setAgeLagel("만 29세 이하")
            cell.setImageView(image: UIImage(named: Const.Logo.MainLogo.withpeaceLogo)!)
        } else {
            cell.setTitleLabel("청년창업 지원사업 예비 창업자 모집 안내")
            cell.setBodyLabel("생애 최초로 창업에 도전하는 ")
            cell.setRegionLabel("서울")
            cell.setAgeLagel("만 29세 이하")
            cell.setImageView(image: UIImage(named: Const.Logo.MainLogo.googleLogo)!)
        }
        
        return cell
    }
}
