//
//  ViewController.swift
//  BestLife
//
//  Created by Mike Griffin on 4/5/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

extension UIViewController {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
