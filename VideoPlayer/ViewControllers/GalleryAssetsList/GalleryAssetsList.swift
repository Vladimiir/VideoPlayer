//
//  GalleryAssetsList.swift
//  VideoPlayer
//
//  Created by Стасенко Владимир on 12.03.2022.
//

import UIKit
import Photos

typealias GalleryAssetsOut = (GalleryAssetsCmd) -> ()

enum GalleryAssetsCmd {
    case assetDidSelect(PHAsset)
}

final class GalleryAssetsList: UIViewController {
    
    // MARK: - Private var
    
    private var allAssets: PHFetchResult<PHAsset>
    
    private var collectionViewLayout: UICollectionViewFlowLayout = {
        let l = UICollectionViewFlowLayout()
        let side = (UIScreen.main.bounds.width - 70) / 4
        l.itemSize = .init(width: side, height: side)
        l.scrollDirection = .vertical
        l.minimumLineSpacing = 10
        return l
    }()
    
    // Subviews
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.contentInset = .init(top: 40, left: 0, bottom: 40, right: 0)
        cv.backgroundColor = .clear
        return cv
    }()
    
    // MARK: - Public var
    
    var out: GalleryAssetsOut?
    
    // MARK: - Private func
    
    private func setupUI() {
        view.addSubview(collectionView)
        
        title = "Gallery assets list"
        view.backgroundColor = .white
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 22,
                                                                                            weight: .semibold),
                                                                   .foregroundColor: UIColor.red,
                                                                   .paragraphStyle: paragraphStyle]
        
        collectionView.register(GalleryItemCell.self, forCellWithReuseIdentifier: "GalleryItemCellIdentifier")
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset,
                                targetSize: CGSize(width: 100, height: 100),
                                contentMode: .aspectFit,
                                options: option,
                                resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    // MARK: - Public func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
    }
    
    init(assets: PHFetchResult<PHAsset>, out: GalleryAssetsOut?) {
        allAssets = assets
        self.out = out
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GalleryAssetsList: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return allAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = allAssets[indexPath.row]
        let image = getAssetThumbnail(asset: asset)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryItemCellIdentifier",
                                                      for: indexPath) as! GalleryItemCell
        
        cell.imageView.image = image
        
        return cell
    }
}

extension GalleryAssetsList: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let asset = allAssets[indexPath.row]
        out?(.assetDidSelect(asset))
        dismiss(animated: true, completion: nil)
    }
}
