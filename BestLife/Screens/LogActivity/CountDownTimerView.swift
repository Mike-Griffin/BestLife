//
//  CountDownTimerView.swift
//  BestLife
//
//  Created by Mike Griffin on 5/4/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

protocol CountDownTimerDelegate : class {
    func countDownComplete(startTime: Date, duration: Double)
    func successfulCountDownStart()
}

class CountDownTimerView : UIView, TimerSubViewProtocol {
    weak var delegate : CountDownTimerDelegate?
    var counter : Double = 0
    var pickerArray : [[String]]
    
    var selectedHours = 0
    var selectedMinutes = 0
    var selectedSeconds = 0
    
    var hasStarted = false
    var isPlaying = false
    
    var initialCountdownTime : Double = 0
    
    var timer = Timer()
    var startTime : Date?
    
    let circleLayer = CAShapeLayer()

    
    var activity : Activity? {
        didSet {
            if let activity = activity {
                circleLayer.strokeColor = UIColor(hex: activity.hex!)!.cgColor
            }
        }
    }
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.Theme.systemLarge
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let countDownTimePicker : UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let countDownTimeSpanView : CountDownTimeSpanView = {
        let view = CountDownTimeSpanView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func didStart() {
        if !hasStarted {
            counter = Double(selectedSeconds) + Double(60) * Double(selectedMinutes) + Double(3600) * Double(selectedHours)
            initialCountdownTime = counter
        }
        if counter != 0 {
            startTime = Date()
            
            delegate?.successfulCountDownStart()
            timeLabel.isHidden = false
            countDownTimePicker.isHidden = true
            countDownTimeSpanView.isHidden = true
            timeLabel.text = counter.timeCounterDisplay()
            showCircle()
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(downCountTimer), userInfo: nil, repeats: true)
            hasStarted = true
            isPlaying = true

        }
        else {
            print("change this to be an alert saying please select time")
//                let ac = UIAlertController(title: "Please enter time", message: nil, preferredStyle: .alert)
        }
    
    }
    
    func didPause() {
        timer.invalidate()
        isPlaying = false
    }
    
    func didStop() {

        didComplete()
    }
    
    fileprivate func showCircle() {
        setCircleDiameter()
        circleLayer.fillColor = .none
        circleLayer.lineWidth = 5
        layer.addSublayer(circleLayer)
    }
    
    fileprivate func setCircleDiameter() {
        let x = safeAreaLayoutGuide.layoutFrame.width / 2
        let y = safeAreaLayoutGuide.layoutFrame.height / 2
        let diameter = safeAreaLayoutGuide.layoutFrame.width / 4
        print(counter, initialCountdownTime, counter / initialCountdownTime)
        let startAngle = CGFloat.pi * 1.5
        let endAngle = CGFloat.pi * 1.5 - (2 * CGFloat.pi) * (CGFloat(counter) / CGFloat(initialCountdownTime))
        circleLayer.path = UIBezierPath(arcCenter: CGPoint(x: x, y: y), radius: diameter, startAngle: startAngle, endAngle: endAngle, clockwise: false).cgPath
    }
    
    @objc fileprivate func downCountTimer() {
        counter = counter - 0.1
        timeLabel.text = counter.timeCounterDisplay()
        setCircleDiameter()
        if counter == 0 {
            print("great success")
            // TODO not sure if this is the right way to handle this case
            didComplete()
        }
    }
    
    func didComplete() {
        timer.invalidate()
        isPlaying = false
        if let startTime = startTime {
            delegate?.countDownComplete(startTime: startTime, duration: initialCountdownTime)
        }
    }
    
    override init(frame: CGRect) {
        let twentyThreeRange = Array(0 ... 23)
        let twentyThreeStrings = twentyThreeRange.map { String($0)}
        let sixtyRange = Array(0 ... 59)
        let sixtyStrings = sixtyRange.map { String($0)}
        pickerArray = [twentyThreeStrings, sixtyStrings, sixtyStrings]
        super.init(frame: frame)
        addSubviews()
        hideViews()
        setupConstraints()
        setupTimePicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addSubviews() {
        addSubview(timeLabel)
        addSubview(countDownTimePicker)
        addSubview(countDownTimeSpanView)
        self.bringSubviewToFront(countDownTimePicker)
    }
    
    fileprivate func hideViews() {
        timeLabel.isHidden = true
    }
    
    fileprivate func setupConstraints() {
        //timeLabel.anchor(top: nil, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 30))
        timeLabel.anchorCenter(centerX: safeAreaLayoutGuide.centerXAnchor, centerY: safeAreaLayoutGuide.centerYAnchor)
        timeLabel.anchorRelativeHeight(height: safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        timeLabel.anchorRelativeWidth(width: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5)
        countDownTimePicker.anchor(top: nil, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor)
        countDownTimePicker.anchorCenter(centerX: nil, centerY: safeAreaLayoutGuide.centerYAnchor)
        countDownTimePicker.anchorRelativeHeight(height: safeAreaLayoutGuide.heightAnchor, multiplier: 0.4)
        countDownTimeSpanView.anchor(top: countDownTimePicker.topAnchor, leading: countDownTimePicker.leadingAnchor, bottom: countDownTimePicker.bottomAnchor, trailing: countDownTimePicker.trailingAnchor)

    }
    
    fileprivate func setupTimePicker() {
        countDownTimePicker.delegate = self
        countDownTimePicker.dataSource = self

    }
    
}

extension CountDownTimerView : UIPickerViewDelegate, UIPickerViewDataSource {
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return String(pickerArray[component][row])
//    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Your Font Name", size: 12)
            pickerLabel?.textAlignment = .center
            pickerLabel?.textColor = .black
        }
        pickerLabel?.text = pickerArray[component][row]

        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected row \(row) in \(component)")
        
        switch component {
        case 0:
            selectedHours = row
        case 1:
            selectedMinutes = row
        case 2:
            selectedSeconds = row
        default:
            print ("Picker select default shouldn't happen")
        }
        
    }
    
}
