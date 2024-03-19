//
//  CustomPhotoAlbumViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/18/24.
//

import UIKit
import Photos

final class CustomPhotoAlbumViewController: UIViewController {
    
    private var smartAlbums = PHFetchResult<PHAssetCollection>()
    private var userCollections = PHFetchResult<PHAssetCollection>()
    private var dataSource: UICollectionViewDiffableDataSource<LayoutSection, PHCollection>?
    
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .defaultLayout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        
        configureLayout()
        registeCollectionViewCell()
        configureDataSource()
        configureDataSourceSnapshot()
    }
}

//MARK: -Configure CollectionView
extension CustomPhotoAlbumViewController {
    
    private func registeCollectionViewCell() {
        collectionView.register(CustomAlbumCell.self, forCellWithReuseIdentifier: CustomAlbumCell.identifier)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<LayoutSection, PHCollection>(collectionView: collectionView) { collectionView, indexPath, identifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomAlbumCell.identifier,
                                                                for: indexPath) as? CustomAlbumCell else {
                return UICollectionViewCell()
            }
            
            guard let assetCollection = identifier as? PHAssetCollection else {
                return UICollectionViewCell()
            }
            
            let targetSize = self.view.frame.width
            if let asset = PHAsset.fetchAssets(in: assetCollection, options: nil).firstObject {
                PHImageManager.default().requestImage(for: asset,
                                                      targetSize: CGSize(width: targetSize,
                                                                         height: targetSize),
                                                      contentMode: .aspectFit,
                                                      options: nil) { image, hash in
                    if let image {
                        cell.setup(image: image)
                    }
                }
            }
            
            cell.setup(title: identifier.localizedTitle ?? "알 수 없는 앨범")
            cell.setup(count: PHAsset.fetchAssets(in: assetCollection, options: nil).count)
            
            return cell
        }
    }
    
    private func configureDataSourceSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<LayoutSection, PHCollection>()
        snapshot.appendSections([.defualt])
        
        //SMART ALBUMS
        smartAlbums = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .albumRegular,
            options: nil)
        
        var id = Array(repeating: PHCollection(), count: 2)
        
        for index in 0..<smartAlbums.count {
            let data = smartAlbums[index]
            
            guard let title = data.localizedTitle else { continue }
            
            switch title {
            case "Recents":
                id[0] = data
            case "Favorites":
                id[1] = data
            default:
                continue
            }
        }
        snapshot.appendItems(id)
        
        // USER COLLECTIONS
        userCollections = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .albumRegular,
            options: nil)
        
        for index in 0..<userCollections.count {
            let data = userCollections[index]
            
            snapshot.appendItems([data])
        }
        
        dataSource?.apply(snapshot)
    }
}

//MARK: - CollectionView Delegate
extension CustomPhotoAlbumViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: Send PHCollection
//        self.navigationController?.pushViewController(ViewController(), animated: true)
        
    }
}

//MARK: -Configure Layout
extension CustomPhotoAlbumViewController {
    
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
}
