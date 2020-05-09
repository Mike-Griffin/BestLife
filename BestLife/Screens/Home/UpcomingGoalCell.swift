//
//  UpcomingGoalCell.swift
//  BestLife
//
//  Created by Mike Griffin on 4/7/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

protocol LogUpcomingGoalDelegate : class {
    func didSelectLogGoal(goal: Goal)
}

class UpcomingGoalCell: UICollectionViewCell {
    weak var delegate : LogUpcomingGoalDelegate?
    
    let habitNameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.Theme.boldCellTitle
        return label
    }()
    
    
    let deadlineDateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.Theme.cellSubheading
        label.textColor = .black
        return label
    }()
    
    lazy var logArrowButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(handleLogButton), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleLogButton() {
        if let goal = goal {
            delegate?.didSelectLogGoal(goal: goal)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 5
    }
    
    var goal : Goal? {
        didSet {
            if let category = goal?.category {
                habitNameLabel.text = category.name!
                logArrowButton.tintColor = UIColor(hex: category.hex!)
            }
            
            if let activity = goal?.activity {
                habitNameLabel.text = activity.name!
                logArrowButton.tintColor = UIColor(hex: activity.hex!)
            }
            
            if let deadline = goal?.deadline {
                let formattedDeadline = deadline.dateToString(format: "MMM d, yyyy")
                deadlineDateLabel.text = "Goal Date: \(formattedDeadline)"
            }
            else if let deadline = goal?.currentStreakDeadline {
                let formattedDeadline = deadline.dateToString(format: "MMM d, yyyy")
                deadlineDateLabel.text = "Streak ends: \(formattedDeadline)"

            }
        }
    }
    
    fileprivate func addSubviews() {
        addSubview(habitNameLabel)
        addSubview(logArrowButton)
        addSubview(deadlineDateLabel)
    }
    
    fileprivate func setupConstraints() {
        let rowHeight : CGFloat = frame.height / 2.0
        habitNameLabel.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 300, height: rowHeight))
        deadlineDateLabel.anchor(top: habitNameLabel.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 300, height: rowHeight))
        logArrowButton.anchor(top: nil, leading: nil, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8), size: .init(width: rowHeight, height: rowHeight))
        logArrowButton.anchorCenter(centerX: nil, centerY: safeAreaLayoutGuide.centerYAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
