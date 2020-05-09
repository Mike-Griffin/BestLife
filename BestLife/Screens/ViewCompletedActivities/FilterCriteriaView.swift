//
//  FilterCriteriaView.swift
//  BestLife
//
//  Created by Mike Griffin on 5/1/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class FilterCriteriaView : UIView {
    let tempLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Search Bar and Other Things will go here"
        label.textAlignment = .center
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
    
    fileprivate func addSubviews() {
        addSubview(tempLabel)
    }
    
    fileprivate func setupConstraints() {
        tempLabel.anchorCenter(centerX: safeAreaLayoutGuide.centerXAnchor, centerY: safeAreaLayoutGuide.centerYAnchor)
        tempLabel.anchorRelativeHeight(height: safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        tempLabel.anchorRelativeWidth(width: safeAreaLayoutGuide.widthAnchor)
    }
}
