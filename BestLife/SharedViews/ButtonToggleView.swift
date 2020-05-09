//
//  ButtonToggleView.swift
//  BestLife
//
//  Created by Mike Griffin on 4/3/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class ButtonToggleView : UIView {
    
    var underLineConstraints = [NSLayoutConstraint]()
    var firstButtonSpecific = [NSLayoutConstraint]()
    var currentButtonSpecific = [NSLayoutConstraint]()
    var buttonSelected : UIButton?

    
    let firstButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        button.setTitleColor(.black, for:  .normal)
        button.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 16)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    let secondButton : UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.sizeToFit()
        button.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 16)
        return button
    }()
    
    let underlineView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#8DBACE")
        return view
    }()
    
    lazy var selectButtonStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstButton, secondButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    init(firstButtonTitle: String, secondButtonTitle: String, noOptionSelected: Bool = false) {
        super.init(frame: .zero)
        // TO DO see if I really need this? Not sure why I put it
        translatesAutoresizingMaskIntoConstraints = false
        setViewUI(firstButtonTitle: firstButtonTitle, secondButtonTitle: secondButtonTitle)
        addSubviews()
        setupConstraints()
        nonButtonSpecificUnderline()
        if !noOptionSelected {
            buttonSpecificUnderlineConstraints()
            updateSelected(selectedButton: firstButton, unSelectedButton: secondButton)
        }
    }
    
    fileprivate func setViewUI(firstButtonTitle: String, secondButtonTitle: String) {
        firstButton.setTitle(firstButtonTitle, for: .normal)
        secondButton.setTitle(secondButtonTitle, for: .normal)
    }
    
    fileprivate func addSubviews() {
        addSubview(selectButtonStackView)
        addSubview(underlineView)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            selectButtonStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            selectButtonStackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            selectButtonStackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.9),
            selectButtonStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)])
    }
    
    fileprivate func nonButtonSpecificUnderline() {
        underLineConstraints = [ underlineView.widthAnchor.constraint(equalTo: firstButton.widthAnchor, multiplier: 0.5),
            underlineView.heightAnchor.constraint(equalToConstant: 2),
        ]
        
        NSLayoutConstraint.activate(underLineConstraints)
        underlineView.isHidden = true
    }

    
    fileprivate func buttonSpecificUnderlineConstraints() {
        currentButtonSpecific = [underlineView.topAnchor.constraint(equalTo: firstButton.bottomAnchor), underlineView.leadingAnchor.constraint(equalTo: firstButton.leadingAnchor)]
        
        NSLayoutConstraint.activate(currentButtonSpecific)
    }
    
    
    func updateSelected(selectedButton: UIButton, unSelectedButton: UIButton) {
        if selectedButton != buttonSelected {
            underlineView.isHidden = false
        
            underlineView.removeConstraints(currentButtonSpecific)
            NSLayoutConstraint.deactivate(currentButtonSpecific)
    //        firstButtonBottom?.isActive = false
            currentButtonSpecific = [underlineView.topAnchor.constraint(equalTo: selectedButton.bottomAnchor), underlineView.leadingAnchor.constraint(equalTo: selectedButton.leadingAnchor)]
            print(currentButtonSpecific)
            NSLayoutConstraint.activate(currentButtonSpecific)
            buttonSelected = selectedButton

//        for constraint in underlineView.constraints {
//            print(constraint)
//        }
//        selectedButton.backgroundColor = UIColor(hex: "#0E4C92")
//        selectedButton.setTitleColor(.white, for: .normal)
//        unSelectedButton.backgroundColor = .white
//        unSelectedButton.setTitleColor(.black, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
