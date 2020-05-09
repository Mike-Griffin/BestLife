//
//  CategoryGoalView.swift
//  BestLife
//
//  Created by Mike Griffin on 4/14/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class CategoryGoalView : UIView {
    let category : Category
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    
    init(category: Category) {
        self.category = category
        super.init(frame: .zero)
        setUIViews()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUIViews() {
        nameLabel.text = category.name!
    }

    
    fileprivate func addSubviews() {
        addSubview(nameLabel)
    }
    
    fileprivate func setupConstraints() {
        nameLabel.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))

    }
}
