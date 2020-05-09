//
//  GoalDetailsView.swift
//  BestLife
//
//  Created by Mike Griffin on 4/15/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class GoalDetailsView : UIView {
    let goal  : Goal
    
    let goalTypeLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let subtitleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    let streakDeadlineLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    init(goal: Goal) {
        self.goal = goal
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        setUIViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addSubviews(){
        addSubview(goalTypeLabel)
        addSubview(subtitleLabel)
        addSubview(streakDeadlineLabel)
    }
    
    fileprivate func setupConstraints() {
        goalTypeLabel.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        subtitleLabel.anchor(top: goalTypeLabel.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 60))
        streakDeadlineLabel.anchor(top: subtitleLabel.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
    }
    
    fileprivate func setUIViews() {
        if goal.currentStreakDeadline != nil {
            setStreakUI()
        }
        if goal.deadline != nil {
            setDeadlineUI()
        }
    }
    
    fileprivate func setStreakUI() {
        goalTypeLabel.text = "Streak"
        subtitleLabel.text = "Streak set to do this goal every \(goal.duration) \(goal.timeSpan!)"
        streakDeadlineLabel.text = "The current streak ends on \(goal.currentStreakDeadline!.dateToString(format: "MMM d, yyyy"))"
    }
    
    fileprivate func setDeadlineUI() {
        goalTypeLabel.text = "Deadline"
        subtitleLabel.text = "Your goal is to complete this by \(goal.deadline!.dateToString(format: "MMM d, yyyy"))"
        streakDeadlineLabel.isHidden = true
        
    }
}
