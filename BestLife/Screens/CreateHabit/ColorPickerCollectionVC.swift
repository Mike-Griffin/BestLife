//
//  ColorPickerCollectionView.swift
//  BestLife
//
//  Created by Mike Griffin on 4/2/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: class {
    func colorSelected(colorHex: String)
}

class ColorPickerCollectionVC : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let colorOptions = ColorHexArrays.defaultColors
    weak var delegate : ColorPickerDelegate?
    
    override func viewDidLoad() {
        collectionView.backgroundColor = .white
        collectionView.register(ColorPickerCell.self, forCellWithReuseIdentifier: Constants.cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellId, for: indexPath) as! ColorPickerCell
        cell.option = colorOptions[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.width / 5
        return CGSize(width: size, height: size)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let parent = parent {
            parent.view.endEditing(true)
        }
        delegate?.colorSelected(colorHex: colorOptions[indexPath.item])
    }
}
