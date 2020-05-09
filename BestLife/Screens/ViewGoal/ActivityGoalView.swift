//
//  ActivityGoalView.swift
//  BestLife
//
//  Created by Mike Griffin on 4/14/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class ActivityGoalView : UIView {
    let activity : Activity
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let categoryLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    init(activity: Activity) {
        self.activity = activity
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        setUIViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUIViews() {
        nameLabel.text = activity.name!
        if activity.category != nil{
            configureCategory()
        }
    }

    fileprivate func addSubviews() {
        addSubview(nameLabel)
    }
    
    fileprivate func setupConstraints() {
        nameLabel.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
    }
    
    fileprivate func configureCategory() {
        categoryLabel.text = "Part of the category \(activity.category!.name!)"
        addSubview(categoryLabel)
        categoryLabel.anchor(top: nameLabel.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
    }
}
