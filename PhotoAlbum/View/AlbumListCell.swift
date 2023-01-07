//
//  AlbumListCell.swift
//  PhotoAlbum
//
//  Created by SangWoo's MacBook on 2023/01/04.
//

import UIKit

final class AlbumListCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "AlbumListCell"
    
    let thumbnailImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.text = "최근"
        
        return label
    }()
    
    let photoCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "1"
        
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        self.addSubView()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - AddSubView
    private func addSubView() {
        self.addSubview(self.thumbnailImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.photoCountLabel)
    }
    
    //MARK: - Layout
    private func layout() {
        NSLayoutConstraint.activate([
            self.thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            self.thumbnailImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.thumbnailImageView.widthAnchor.constraint(equalToConstant: 70),
            self.thumbnailImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.thumbnailImageView.trailingAnchor, constant: 20),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.thumbnailImageView.centerYAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            self.photoCountLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.photoCountLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4)
        ])
    }
}
