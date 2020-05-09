//
//  DeadlineFieldsViewController.swift
//  BestLife
//
//  Created by Mike Griffin on 4/5/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class DeadlineFieldsVC : UIViewController {
    let datePickerLauncher = DatePickerLauncher()
    
    let promptLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let dateButton : UIButton = {
        let button = UIButton()
        button.setTitle("Select Date", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleDateButton), for: .touchUpInside)
        return button
    }()
    
    
    @objc fileprivate func handleDateButton() {
        datePickerLauncher.showDatePicker()
    }
    
    var habitType: HabitType? {
        didSet {
            if let habitType = habitType {
                switch habitType {
                case .Activity:
                    promptLabel.text = "Log An Event For This Activity By"
                case .Category:
                    promptLabel.text = "Log An Activity From This Category By"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        setViewUI()
        configureChildren()
        addSubviews()
        setupConstraints()
    }
    
    fileprivate func setViewUI() {
        view.backgroundColor = .white
    }
    
    fileprivate func configureChildren() {
        addChild(datePickerLauncher)
    }
    
    fileprivate func addSubviews() {
        view.addSubview(promptLabel)
        view.addSubview(dateButton)
    }
    
    fileprivate func setupConstraints() {
        promptLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        dateButton.anchor(top: promptLabel.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 40))
    }
}
