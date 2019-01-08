//
//  UIViewController.swift
//  Sky
//
//  Created by kuroky on 2019/1/8.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit

extension UIViewController {
    func modalAlert(title: String,
                    message: String,
                    accept: String = .ok,
                    cancel: String = .cancel,
                    callback: @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: cancel, style: .cancel, handler: { (_) in
            return
        }))
        
        alert.addAction(UIAlertAction.init(title: accept, style: .default, handler: { (_) in
            callback()
        }))
        
        return alert
    }
}

extension String {
    static let ok = NSLocalizedString("Retry", comment: "")
    static let cancel = NSLocalizedString("Cancel", comment: "")
}
