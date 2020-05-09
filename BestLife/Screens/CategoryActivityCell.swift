//
//  CategoryActivityCell.swift
//  BestLife
//
//  Created by Mike Griffin on 4/8/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class CategoryActivityCell : UICollectionViewCell {
    let categoryLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    let activitiesCollectionView : HabitPickerCollectionVC = {
        let layout = UICollectionViewFlowLayout()
        let cv = HabitPickerCollectionVC(collectionViewLayout: layout)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var category: Category? {
        didSet {
            if let category = category {
                categoryLabel.text = category.name
            }
        }
    }
    
    var activities : [Activity]? {
        didSet {
            if let activities = activities {
                activitiesCollectionView.habits = activities
                activitiesCollectionView.collectionView.reloadData()
            }
        }
    }
    
    fileprivate func addSubviews() {
        addSubview(categoryLabel)
        addSubview(activitiesCollectionView.view)
    }
    
    fileprivate func setupConstraints() {
        categoryLabel.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 30))
        activitiesCollectionView.view.anchor(top: categoryLabel.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor)
    }
}
