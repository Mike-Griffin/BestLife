//
//  MenuSelectCell.swift
//  BestLife
//
//  Created by Mike Griffin on 4/6/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class MenuSelectCell : UICollectionViewCell {
    let selectedIcon : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectedIcon.image = UIImage(systemName: "largecircle.fill.circle")
            }
            else {
                selectedIcon.image = UIImage(systemName: "circle")
            }
        }
    }
    
    var option: String? {
        didSet {
            if let option = option {
                nameLabel.text = option
            }
        }
    }
    
    fileprivate func addSubviews() {
        addSubview(selectedIcon)
        addSubview(nameLabel)
    }
    
    fileprivate func setupConstraints() {
        selectedIcon.anchor(top: nil, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 20, height: 20))
        selectedIcon.anchorCenter(centerX: nil, centerY: safeAreaLayoutGuide.centerYAnchor)
        nameLabel.anchor(top: nil, leading: selectedIcon.trailingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        nameLabel.anchorCenter(centerX: nil, centerY: safeAreaLayoutGuide.centerYAnchor)
    }
}
