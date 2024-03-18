//
//  CustomPhotoAlbumViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/18/24.
//

import UIKit

final class CustomPhotoAlbumViewController: UIViewController {
    
    private var dataSource: UICollectionViewDiffableDataSource<LayoutSection, String>?
    
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .defaultLayout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        PHPhotoLibrary.shared().register(self)
        
        configureLayout()
        registeCollectionViewCell()
        configureDataSource()
        configureDataSourceSnapshot()
    }
    
    
    private func configureLayout() {
        view.addSubview(collectionView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func registeCollectionViewCell() {
        collectionView.register(CustomAlbumCell.self, forCellWithReuseIdentifier: CustomAlbumCell.identifier)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<LayoutSection, String>(collectionView: collectionView) { collectionView, indexPath, identifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomAlbumCell.identifier, for: indexPath) as? CustomAlbumCell else {
                return UICollectionViewCell()
            }
            
            return cell
        }
    }
    private func configureDataSourceSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<LayoutSection, String>()
        snapshot.appendSections([.defualt])
        
        for i in 0..<10 {
//            let asset = allPhotos.object(at: i)
            
            snapshot.appendItems([String(i)])
        }
        
        dataSource?.apply(snapshot)
    }
}
