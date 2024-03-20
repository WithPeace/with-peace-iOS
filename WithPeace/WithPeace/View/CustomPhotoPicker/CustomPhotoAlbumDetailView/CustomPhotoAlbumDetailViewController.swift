//
//  CustomPhotoAlbumDetailViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/20/24.
//

import UIKit
import Photos

final class CustomPhotoAlbumDetailViewController: UIViewController {
    
    private var toastMessage: ToastMessageView?
    private var maxSelect: Int
    private var selectedIndex = [Int]()
    
    private var albumCollection = PHCollection()
    private var dataSource: UICollectionViewDiffableDataSource<LayoutSection, PHAsset>?
    
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .albumLayout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        
        configureLayout()
        registeCollectionViewCell()
        configureDataSource()
        configureDataSourceSnapshot()
    }
    
    init(albumCollection: PHCollection, totalPhotoCount: Int) {
        self.albumCollection = albumCollection
        self.maxSelect = totalPhotoCount
        super.init(nibName: nil, bundle: nil)
        self.toastMessage = ToastMessageView(superView: self.view)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("DEINIT - CustomPhotoAlbumDetailViewController")
    }
}

//MARK: -Configure CollectionView
extension CustomPhotoAlbumDetailViewController {
    
    private func registeCollectionViewCell() {
        collectionView.register(AlbumDetailCell.self, forCellWithReuseIdentifier: AlbumDetailCell.identifier)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<LayoutSection, PHAsset>(collectionView: collectionView) { collectionView, indexPath, identifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumDetailCell.identifier,
                                                                for: indexPath) as? AlbumDetailCell else {
                return UICollectionViewCell()
            }
            
            //TODO: TargetSize setting
            PHCachingImageManager().requestImage(for: identifier,
                                           targetSize: CGSize(width: 150, height: 150),
                                           contentMode: .aspectFill,
                                           options: nil) { image, _ in
                guard let image = image else { return }
                cell.setup(image: image)
            }
            
            return cell
        }
    }
    
    private func configureDataSourceSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<LayoutSection, PHAsset>()
        snapshot.appendSections([.DetailPhotos])
        
        let phFetchResult = PHAsset.fetchAssets(in: albumCollection as! PHAssetCollection, options: nil)
        
        for i in 0..<phFetchResult.count {
            let asset = phFetchResult.object(at: i)
            
            snapshot.appendItems([asset])
        }
        
        dataSource?.apply(snapshot)
    }
}

//MARK: - CollectionView Delegate
extension CustomPhotoAlbumDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //TODO: Check Cell
        guard let cell = collectionView.cellForItem(at: indexPath) as? AlbumDetailCell else { return }
        
        if selectedIndex.contains(indexPath.row) {
            selectedIndex.remove(at: selectedIndex.firstIndex(of: indexPath.row)!)
            cell.deselectCell()
        } else if selectedIndex.count >= maxSelect {
            toastMessage?.presentStandardToastMessage("더 이상 이미지를 선택할 수 없습니다")
        } else {
            selectedIndex.append(indexPath.row)
            cell.selectCell()
        }
    }
}

//MARK: -Configure Layout
extension CustomPhotoAlbumDetailViewController {
    
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
