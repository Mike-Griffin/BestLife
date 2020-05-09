//
//  CountUpTimerView.swift
//  BestLife
//
//  Created by Mike Griffin on 5/4/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

protocol CountUpTimerDelegate : class {
    func countUpComplete(startTime: Date, duration: Int)
}

class CountUpTimerView : UIView {
    weak var delegate : CountUpTimerDelegate?
    var timer = Timer()
    var hasStarted = false
    var isPlaying = false
    var counter : Double = 0
    var startTime : Date?

    let timeLabel : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.Theme.systemLarge
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    func didStart() {
        if !hasStarted {
            startTime = Date()
        }
        
        timeLabel.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(upCountTimer), userInfo: nil, repeats: true)
        hasStarted = true
        isPlaying = true
    }
    
    func didPause() {
        timer.invalidate()
        isPlaying = false
    }
    
    func didStop() {
        didComplete()
    }
    
    func didComplete() {
        if let startTime = startTime {
            delegate?.countUpComplete(startTime: startTime, duration: Int(counter))
        }
    }
    
    @objc fileprivate func upCountTimer() {
        counter = counter + 1
        timeLabel.text = counter.timeCounterDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        hideViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addSubviews() {
        addSubview(timeLabel)
    }
    
    fileprivate func hideViews() {
        timeLabel.isHidden = true
    }
    
    fileprivate func setupConstraints() {
        timeLabel.anchorCenter(centerX: safeAreaLayoutGuide.centerXAnchor, centerY: safeAreaLayoutGuide.centerYAnchor)
        timeLabel.anchorRelativeHeight(height: safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        timeLabel.anchorRelativeWidth(width: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5)
    }
}
