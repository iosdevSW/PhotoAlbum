//
//  AlbumViewController.swift
//  PhotoAlbum
//
//  Created by SangWoo's MacBook on 2023/01/04.
//

import UIKit
import Photos

final class AlbumViewController: UIViewController {
    //MARK: - Properties
    private let assets: PHFetchResult<PHAsset>
    private let cellSpacing: CGFloat = 4
    private var cellSize: CGFloat!
    
    
    private let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.identifier)
        view.backgroundColor = .white
        
        return view
    }()
    
    init(_ assets: PHFetchResult<PHAsset>) {
        self.assets = assets
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.addSubView()
        self.layout()
        
        self.cellSize = (self.view.frame.width - 8) / 3
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
    }
    
    //MARK: - AddSubView
    private func addSubView() {
        self.view.addSubview(self.photoCollectionView)
    }

    //MARK: - Layout
    private func layout() {
        NSLayoutConstraint.activate([
            self.photoCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.photoCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.photoCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.photoCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.identifier, for: indexPath) as! AlbumCell
        PHImageManager().requestImage(for: self.assets[indexPath.row],
                                      targetSize: CGSize(width: self.cellSize*2, height: self.cellSize*2),
                                      contentMode: .default,
                                      options: nil) { image, _ in
            cell.imageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = assets[indexPath.row]
        guard let resource = PHAssetResource.assetResources(for: asset).first else { return }
        let size = resource.value(forKey: "fileSize") as! Int64
        let name = resource.originalFilename
        let fileSize = ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
        
        self.defalutAlert(title: "사진정보",
                          message: """
                                    파일명 : \(name)
                                    파일크기 : \(fileSize)
                                    """)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellSize,
                      height: self.cellSize)
    }
}

