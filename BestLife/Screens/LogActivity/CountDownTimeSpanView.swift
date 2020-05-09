//
//  CountDownTimeSpanView.swift
//  BestLife
//
//  Created by Mike Griffin on 5/4/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class CountDownTimeSpanView : UIView {
    let hoursLabel : UILabel = {
        let label = UILabel()
        label.text = "hours"
        label.textColor = .darkGray
        label.textAlignment = .right
        return label
    }()
    
    let minutesLabel : UILabel = {
        let label = UILabel()
        label.text = "mins"
        label.textColor = .darkGray
        label.textAlignment = .right
        return label
    }()
    
    let secondsLabel : UILabel = {
        let label = UILabel()
        label.text = "secs"
        label.textColor = .darkGray
        label.textAlignment = .right
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
        addSubview(hoursLabel)
        addSubview(minutesLabel)
        addSubview(secondsLabel)
    }
    
    fileprivate func setupConstraints() {
        hoursLabel.anchor(top: nil, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil)
        hoursLabel.anchorRelativeWidth(width: safeAreaLayoutGuide.widthAnchor, multiplier: 0.33)
        hoursLabel.anchorCenter(centerX: nil, centerY: safeAreaLayoutGuide.centerYAnchor)
        minutesLabel.anchorCenter(centerX: nil, centerY: safeAreaLayoutGuide.centerYAnchor)
        minutesLabel.anchor(top: nil, leading: hoursLabel.trailingAnchor, bottom: nil, trailing: nil)
        minutesLabel.anchorRelativeWidth(width: hoursLabel.widthAnchor)
        secondsLabel.anchorCenter(centerX: nil, centerY: safeAreaLayoutGuide.centerYAnchor)
        secondsLabel.anchor(top: nil, leading: minutesLabel.trailingAnchor, bottom: nil, trailing: nil)
        secondsLabel.anchorRelativeWidth(width: hoursLabel.widthAnchor)
    }
}
