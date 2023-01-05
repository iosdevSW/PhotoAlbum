//
//  PhotoAlbumListViewController.swift
//  PhotoAlbum
//
//  Created by SangWoo's MacBook on 2023/01/04.
//

import UIKit
import Photos

final class PhotoAlbumListViewController: UIViewController {
    //MARK: - Properties
    private var albumList: [PHAssetCollection] = []
    
    private let albumListTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.register(AlbumListCell.self, forCellReuseIdentifier: AlbumListCell.identifier)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.authorizationPhotoLibrary()
        
        self.addSubView()
        self.layout()
        self.configureNavigation()
        
        self.albumListTableView.delegate = self
        self.albumListTableView.dataSource = self
    }
    
    //MARK: - 사진첩 권한 체크
    private func authorizationPhotoLibrary() {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) != .authorized {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .authorized: print("authorized");self.getPhotoAlbumListInfo()
                case .limited: print("limited") // 몇가지 사진에 대해서만 허용
                default : self.showAuthAlert()
                }
            }
        } else {
            self.getPhotoAlbumListInfo()
        }
    }
    
    private func showAuthAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "사진첩 권한 요청", message: "사진첩 권한이 제한되어 앱을 이용하실 수 없습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "권한 변경하기", style: .default) { _ in
                if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSetting)
                }
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true)
        }
    }
    
    private func getPhotoAlbumListInfo() {
        PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil).enumerateObjects { collection,_,_ in
            self.albumList.append(collection)
        }
    }
    
    private func configureNavigation() {
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
        self.navigationItem.title = "앨범"
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    //MARK: - AddSubView
    private func addSubView() {
        self.view.addSubview(self.albumListTableView)
    }
    
    //MARK: - Layout
    private func layout() {
        NSLayoutConstraint.activate([
            self.albumListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.albumListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.albumListTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.albumListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension PhotoAlbumListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumListCell.identifier, for: indexPath) as! AlbumListCell
        cell.selectionStyle = .none
        cell.titleLabel.text = self.albumList[indexPath.row].localizedTitle ?? "error"
        cell.photoCountLabel.text = String(self.albumList[indexPath.row].estimatedAssetCount)
        
        let option = PHFetchOptions()
        option.fetchLimit = 1
        let asset = PHAsset.fetchAssets(in: albumList[indexPath.row], options: option).firstObject!
        PHImageManager().requestImage(for: asset, targetSize: .init(width: 70, height: 70), contentMode: .aspectFit, options: nil) { image, _ in
            cell.thumbnailImageView.image = image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assets = PHAsset.fetchAssets(in: albumList[indexPath.row], options: nil)
        let albumVC = AlbumViewController(assets)
        albumVC.navigationItem.title = albumList[indexPath.row].localizedTitle
        self.navigationController?.pushViewController(albumVC, animated: true)
    }
}
