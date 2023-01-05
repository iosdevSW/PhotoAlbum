//
//  UIViewController+.swift
//  PhotoAlbum
//
//  Created by SangWoo's MacBook on 2023/01/05.
//

import UIKit

extension UIViewController {
    func defalutAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
    
        self.present(alert, animated: true)
    }
}
