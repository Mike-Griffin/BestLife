//
//  Alert.swift
//  BestLife
//
//  Created by Mike Griffin on 4/12/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

struct Alert {
    static func errorAlert(title: String, message: String?, cancelButton: Bool = false, completion: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default) {
            _ in
            guard let completion = completion else { return }
            completion()
        }
        alert.addAction(actionOK)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if cancelButton { alert.addAction(cancel) }

        return alert
    }
    
    static func infoAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        return alert
    }
}
