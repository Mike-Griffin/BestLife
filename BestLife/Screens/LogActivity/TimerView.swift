//
//  TimerView.swift
//  BestLife
//
//  Created by Mike Griffin on 4/10/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

protocol TimerActivitySaveDelegate : class {
    func didSaveTimerActivity(startTime: Date, endTime: Date, duration: Int)
}

protocol TimerSubViewProtocol {
    func didStart()
    func didComplete()
}

class TimerView : UIView, CountDownTimerDelegate, CountUpTimerDelegate {
    weak var delegate : TimerActivitySaveDelegate?
    var selectedTimerMode : TimerMode = .countUp

    let coreDataService = CoreDataService()
    
    var endTime : Date?
    var startTime : Date?
    
    var currentState : TimerViewState = .typeSelect
    var duration = 0
    
    var activity : Activity? {
        didSet {
            countDownTimerView.activity = activity
        }
    }
    
    let buttonToggleView : ButtonToggleView = {
        let view = ButtonToggleView(firstButtonTitle: "Count Up", secondButtonTitle: "Count Down", noOptionSelected: true)
        view.firstButton.setTitle("Count Up", for: .normal)
        view.secondButton.setTitle("Count Down", for: .normal)
        return view
    }()
    
    let startButton : UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleStart), for: .touchUpInside)
        return button
    }()
    
    let pauseButton : UIButton = {
        let button = UIButton()
        button.setTitle("Pause", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    
    let stopButton : UIButton = {
        let button = UIButton()
        button.setTitle("Stop", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleStop), for: .touchUpInside)
        return button
    }()
    
    let saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("Save Activity", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let countDownTimerView : CountDownTimerView = {
        let view = CountDownTimerView()
        return view
    }()
    
    let countUpTimerView : CountUpTimerView = {
        let view = CountUpTimerView()
        return view
    }()
    
    let timeDisplayContainer : UIView = {
        let view = UIView()
        return view
    }()
    
    @objc fileprivate func handleCountDown() {
        print("count downnnn")
        selectedTimerMode = .countDown
        currentState = .start
        updateDisplays()
    }
    
    @objc fileprivate func handleCountUp() {
        print("Count upppp")
        selectedTimerMode = .countUp
        currentState = .start
        updateDisplays()
    }
    
    @objc fileprivate func handleStart() {
        if(countDownTimerView.isPlaying || countUpTimerView.isPlaying) {
            return
        }

        if selectedTimerMode == .countUp {
            currentState = .running
            updateDisplays()
            countUpTimerView.didStart()
        }
        else {
            countDownTimerView.didStart()
        }
    }
    
    @objc fileprivate func handlePause() {
        currentState = .paused
        updateDisplays()
        if selectedTimerMode == .countUp {
            countUpTimerView.didPause()
        }
        else {
            countDownTimerView.didPause()
        }
    }
    
    @objc fileprivate func handleStop() {
        if selectedTimerMode == .countUp {
            countUpTimerView.didStop()
        }
        else {
            countDownTimerView.didStop()
        }
        subTimerComplete()
    }
    
    func countDownComplete(startTime: Date, duration: Double) {
        self.startTime = startTime
        self.duration = Int(duration)
        subTimerComplete()
    }
    
    func countUpComplete(startTime: Date, duration: Int) {
        self.startTime = startTime
        self.duration = duration
    }
    
    fileprivate func updateDisplays() {
        switch currentState {
        case .typeSelect:
            hideViews([timeDisplayContainer, startButton, pauseButton, stopButton, saveButton, cancelButton])
            showViews([buttonToggleView])
        case .start:
            showViews([startButton, timeDisplayContainer])
            switch selectedTimerMode {
            case .countUp:
                buttonToggleView.updateSelected(selectedButton: buttonToggleView.firstButton, unSelectedButton: buttonToggleView.secondButton)
                countDownTimerView.isHidden = true
                countUpTimerView.isHidden = false
            case .countDown:
                buttonToggleView.updateSelected(selectedButton: buttonToggleView.secondButton, unSelectedButton: buttonToggleView.firstButton)
                countUpTimerView.isHidden = true
                countDownTimerView.isHidden = false
            }
        case .running:
            showViews([pauseButton, stopButton])
            hideViews([buttonToggleView, startButton])
        case .paused:
            startButton.isHidden = false
            pauseButton.isHidden = true
        case .stopped:
            hideViews([pauseButton, startButton, stopButton])
            showViews([saveButton, cancelButton])
        }
    }
    
    fileprivate func hideViews(_ views : [UIView]) {
        for view in views {
            view.isHidden = true
        }
    }
    
    fileprivate func showViews(_ views: [UIView]) {
        for view in views {
            view.isHidden = false
        }
    }
    
    func successfulCountDownStart() {
        currentState = .running
        updateDisplays()
    }
    
    func subTimerComplete() {
        currentState = .stopped
        updateDisplays()
        endTime = Date()

    }
    
    @objc fileprivate func handleSave() {
        print("do this stufffff")
        if let startTime = startTime, let endTime = endTime {
            if selectedTimerMode == .countUp {
                delegate?.didSaveTimerActivity(startTime: startTime, endTime: endTime, duration: duration)
            }
            else {
                delegate?.didSaveTimerActivity(startTime: startTime, endTime: endTime, duration: duration)
            }
//            coreDataService.saveEvent(activity: activity, startTime: startTime, endTime: endTime, duration: counter)
        }
    }
    
    @objc fileprivate func handleCancel() {
        print("cancel")
        currentState = .typeSelect
        updateDisplays()
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configDelegates()
        setupConstraints()
        updateDisplays()
        setupButtonToggleView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addSubviews() {
        addSubview(buttonToggleView)
        addSubview(timeDisplayContainer)
        timeDisplayContainer.addSubview(countDownTimerView)
        timeDisplayContainer.addSubview(countUpTimerView)
        addSubview(startButton)
        addSubview(pauseButton)
        addSubview(stopButton)
        addSubview(saveButton)
        addSubview(cancelButton)
    }
    
    fileprivate func configDelegates() {
        countDownTimerView.delegate = self
    }
    
    fileprivate func setupConstraints() {
        buttonToggleView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor)
        buttonToggleView.anchorRelativeHeight(height: safeAreaLayoutGuide.heightAnchor, multiplier: 0.1)
        timeDisplayContainer.anchor(top: buttonToggleView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        timeDisplayContainer.anchorRelativeHeight(height: safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        timeDisplayContainer.anchorCenter(centerX: safeAreaLayoutGuide.centerXAnchor, centerY: nil)
        timeDisplayContainer.anchorRelativeWidth(width: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9)
        countDownTimerView.anchor(top: timeDisplayContainer.topAnchor, leading: timeDisplayContainer.leadingAnchor, bottom: timeDisplayContainer.bottomAnchor, trailing: timeDisplayContainer.trailingAnchor)
        countUpTimerView.anchor(top: timeDisplayContainer.topAnchor, leading: timeDisplayContainer.leadingAnchor, bottom: timeDisplayContainer.bottomAnchor, trailing: timeDisplayContainer.trailingAnchor)
        startButton.anchor(top: timeDisplayContainer.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 32, bottom: 0, right: 32), size: .init(width: 0, height: 30))
        pauseButton.anchor(top: startButton.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 32, bottom: 0, right: 32), size: .init(width: 0, height: 30))
        stopButton.anchor(top: pauseButton.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 32, bottom: 0, right: 32), size: .init(width: 0, height: 30))
        saveButton.anchor(top: pauseButton.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 32, bottom: 0, right: 32), size: .init(width: 0, height: 30))
        cancelButton.anchor(top: saveButton.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 32, bottom: 0, right: 32), size: .init(width: 0, height: 30))
    }
    
    fileprivate func setupButtonToggleView() {
        buttonToggleView.firstButton.addTarget(self, action: #selector(handleCountUp), for: .touchUpInside)
        buttonToggleView.secondButton.addTarget(self, action: #selector(handleCountDown), for: .touchUpInside)
    }
}


