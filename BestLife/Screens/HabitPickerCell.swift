//
//  HabitPickerCell.swift
//  BestLife
//
//  Created by Mike Griffin on 4/2/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class HabitPickerCell : UICollectionViewCell {
    let habitNameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    let habitColorCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    var habit : Habit? {
        didSet {
            if let habit = habit {
                habitNameLabel.text = habit.name
                // TODO make this not optional
                if let hex = habit.hex {
                    habitColorCircle.backgroundColor = UIColor(hex: hex)
                }
            }
        }
    }
    
    fileprivate func addSubviews() {
        addSubview(habitColorCircle)
        addSubview(habitNameLabel)
    }
    
    fileprivate func setupConstraints() {
        habitColorCircle.anchor(top: nil, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 20, height: 20))
        habitColorCircle.anchorCenter(centerX: nil, centerY: safeAreaLayoutGuide.centerYAnchor)
        habitNameLabel.anchor(top: safeAreaLayoutGuide.topAnchor, leading: habitColorCircle.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: frame.width, height: 30))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
