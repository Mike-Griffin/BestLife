//
//  SlideUpLaunch.swift
//  BestLife
//
//  Created by Mike Griffin on 4/7/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class SlideUpLauncher {
    let subview : UIView
    let height : CGFloat
    let blackView = UIView()

    init(subview: UIView, height : CGFloat) {
        self.subview = subview
        self.height = height
    }
    
    func showSlideUpView() {

        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            self.blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            window.addSubview(blackView)
            
            self.blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))

            
            window.addSubview(self.subview)
            
            
            let y = window.frame.height - height
            subview.frame = CGRect(x: 0, y: y, width: window.frame.width, height: height)
            
            self.blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.subview.frame = CGRect(x: 0, y: y, width: self.subview.frame.width, height: self.subview.frame.height)

            }, completion: nil)
            
            
            UIView.animate(withDuration: 0.5, animations: {
            })
            blackView.anchor(top: window.topAnchor, leading: window.leadingAnchor, bottom: window.bottomAnchor, trailing: window.trailingAnchor)
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                self.subview.frame = CGRect(x: 0, y: window.frame.height, width: self.subview.frame.width, height: self.subview.frame.height)
            }
        })
    }
}
