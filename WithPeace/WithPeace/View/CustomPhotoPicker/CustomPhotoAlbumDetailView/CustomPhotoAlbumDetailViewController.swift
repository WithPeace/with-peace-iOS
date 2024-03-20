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
//    private var selectedIndexs = [Int]()
    private var selectedAssets: [PHAsset]
    
    var completionHandler: (([PHAsset]) -> ())?
    
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
    
    init(albumCollection: PHCollection, totalPhotoCount: Int, selectedAssets: [PHAsset]) {
        self.albumCollection = albumCollection
        self.maxSelect = totalPhotoCount
        self.selectedAssets = selectedAssets
        super.init(nibName: nil, bundle: nil)
        self.toastMessage = ToastMessageView(superView: self.view)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        completionHandler?(selectedAssets)
    }
    
    deinit {
        debugPrint("DEINIT - CustomPhotoAlbumDetailViewController")
        
//        var assets = [PHAsset]()
//        
//        for index in 1...selectedAssets.count {
//            if let data =  dataSource?.snapshot().itemIdentifiers[index] {
//                assets.append(data)
//            }
//        }
//        completionHandler?(assets)
        
    }
}

//MARK: -Configure CollectionView
extension CustomPhotoAlbumDetailViewController {
    
    private func registeCollectionViewCell() {
        collectionView.register(AlbumDetailCell.self, forCellWithReuseIdentifier: AlbumDetailCell.identifier)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<LayoutSection, PHAsset>(collectionView: collectionView) { [weak self] collectionView, indexPath, identifier in
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
            guard let assets = self?.selectedAssets else { return UICollectionViewCell() }
            
            for selectedAsset in assets {
                if selectedAsset == self?.dataSource?.snapshot().itemIdentifiers[indexPath.row] {
                    cell.selectCell()
                }
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
        
        guard let dataSourceAssets = dataSource?.snapshot().itemIdentifiers else {
            return
        }
        
        for selectedAssetIndex in 0..<selectedAssets.count {
            if dataSourceAssets[indexPath.row] == selectedAssets[selectedAssetIndex] {
                selectedAssets.remove(at: selectedAssetIndex)
                cell.deselectCell()
                return
            }
        }
        
        if selectedAssets.count >= maxSelect {
            toastMessage?.presentStandardToastMessage("더 이상 이미지를 선택할 수 없습니다")
        } else {
            selectedAssets.append(dataSourceAssets[indexPath.row])
            cell.selectCell()
        }
        
//        if selectedAssets.contains(asset) {
//            selectedAssets.remove(at: selectedAssets.firstIndex(of: indexPath.row)!)
//            cell.deselectCell()
//        } else if selectedAssets.count >= maxSelect {
//            toastMessage?.presentStandardToastMessage("더 이상 이미지를 선택할 수 없습니다")
//        } else {
//            selectedAssets.append(indexPath.row)
//            cell.selectCell()
//        }
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
