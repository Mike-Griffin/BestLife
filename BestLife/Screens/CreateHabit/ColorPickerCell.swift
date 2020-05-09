//
//  ColorPickerCell.swift
//  BestLife
//
//  Created by Mike Griffin on 4/2/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class ColorPickerCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = frame.width / 2
    }

    var option: String? {
        didSet {
            if let option = option {
                self.backgroundColor = UIColor(hex: option)
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 3
            }
            else {
                layer.borderWidth = 0
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
