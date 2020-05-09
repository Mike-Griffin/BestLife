//
//  StreakFieldsViewController.swift
//  BestLife
//
//  Created by Mike Griffin on 4/5/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class StreakFieldsVC : UIViewController, MenuOptionSelectedDelegate {
    
    var selectedTimeSpan : TimeSpan = .Days
    let menuLauncher = MenuLauncher(options: [TimeSpan.Days.rawValue, TimeSpan.Weeks.rawValue, TimeSpan.Months.rawValue])
    
    let promptLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let numberTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.layer.borderWidth = 1
        textField.keyboardType = .numberPad
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: "#",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return textField
    }()
    
    let timeSpanLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    let timeSpanSelectButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        button.tintColor = .blue
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleTimeSpanSelectButton), for: .touchUpInside)
        //button.backgroundColor = .red
        return button
    }()
    
    let timeSpanSelectView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        return view
    }()
    
    @objc func handleTimeSpanSelectButton() {
        menuLauncher.showMenu()
    }
    
    var habitType: HabitType? {
        didSet {
            if let habitType = habitType {
                switch habitType {
                case .Activity:
                    promptLabel.text = "Do This Activity Every"
                case .Category:
                    promptLabel.text = "Do An Activity From This Category Every"
                }
            }
        }
    }
    
    func didSelectOption(option: String) {
        selectedTimeSpan = TimeSpan(rawValue: option)!
        timeSpanLabel.text = option
    }
    
    fileprivate func updateTimeSpanLabel() {
        timeSpanLabel.text = selectedTimeSpan.rawValue
    }
    
    override func viewDidLoad() {
        menuLauncher.delegate = self
        setViewUI()
        addSubviews()
        setupConstraints()
        updateTimeSpanLabel()
    }
    
    fileprivate func setViewUI() {
        view.backgroundColor = .white
    }
    
    fileprivate func addSubviews() {
        view.addSubview(promptLabel)
        view.addSubview(numberTextField)
        view.addSubview(timeSpanSelectView)
        timeSpanSelectView.addSubview(timeSpanLabel)
        timeSpanSelectView.addSubview(timeSpanSelectButton)
    }
    
    fileprivate func setupConstraints() {
        
        promptLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        numberTextField.anchor(top: promptLabel.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: view.frame.width / 3, bottom: 0, right: 0), size: .init(width: 40, height: 30))
        timeSpanSelectView.anchor(top: numberTextField.topAnchor, leading: numberTextField.trailingAnchor, bottom: numberTextField.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 100, height: 0))
        timeSpanLabel.anchor(top: timeSpanSelectView.topAnchor, leading: timeSpanSelectView.leadingAnchor, bottom: timeSpanSelectView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 60, height: 0))
        timeSpanSelectButton.anchor(top: timeSpanSelectView.topAnchor, leading: nil, bottom: timeSpanSelectView.bottomAnchor, trailing: timeSpanSelectView.trailingAnchor, size: .init(width: 40, height: 0))
        
    }
}
