//
//  CreateHabitScreenVC.swift
//  BestLife
//
//  Created by Mike Griffin on 4/1/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class CreateHabitScreenVC : UIViewController {    
    var selectedHabitType = HabitType.Activity
    
    let buttonToggleView : ButtonToggleView = {
        let view = ButtonToggleView(firstButtonTitle: HabitType.Activity.rawValue, secondButtonTitle: HabitType.Category.rawValue)
        return view
    }()
    
    let activityFieldsVC : ActivityFieldsVC = {
        let vc = ActivityFieldsVC()
        return vc
    }()
    
    let categoryFieldsVC : CategoryFieldsVC = {
        let vc = CategoryFieldsVC()
        return vc
    }()
    
    override func viewDidLoad() {
        setViewUI()
        setupButtonToggleView()
        configureChildren()
        addSubviews()
        setupConstraints()
    }
    
    fileprivate func setupButtonToggleView() {
        habitToggled()
        buttonToggleView.firstButton.addTarget(self, action: #selector(handleActivitySelectButton), for: .touchUpInside)
        buttonToggleView.secondButton.addTarget(self, action: #selector(handleCategorySelectButton), for: .touchUpInside)
    }
    
    @objc fileprivate func handleActivitySelectButton() {
        selectedHabitType = HabitType.Activity
        habitToggled()
    }
    
    @objc fileprivate func handleCategorySelectButton() {
        selectedHabitType = HabitType.Category
        habitToggled()
    }

    
    fileprivate func habitToggled() {
        switch selectedHabitType {
        case HabitType.Activity:
            buttonToggleView.updateSelected(selectedButton: buttonToggleView.firstButton, unSelectedButton: buttonToggleView.secondButton)
            activityFieldsVC.view.isHidden = false
            categoryFieldsVC.view.isHidden = true
        case HabitType.Category:
                buttonToggleView.updateSelected(selectedButton: buttonToggleView.secondButton, unSelectedButton: buttonToggleView.firstButton)
                activityFieldsVC.view.isHidden = true
                categoryFieldsVC.view.isHidden = false
        }
    }
    
    fileprivate func setViewUI() {
        view.backgroundColor = .white
        self.title = "Create Habit"
    }
    
    fileprivate func configureChildren() {
        addChild(activityFieldsVC)
        activityFieldsVC.didMove(toParent: self)
        addChild(categoryFieldsVC)
        categoryFieldsVC.didMove(toParent: self)
    }

    
    fileprivate func addSubviews() {
        view.addSubview(buttonToggleView)
        view.addSubview(activityFieldsVC.view)
        view.addSubview(categoryFieldsVC.view)
    }
    
    fileprivate func setupConstraints() {
        let sidePadding = view.frame.width / 10
        buttonToggleView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 24, left: sidePadding, bottom: 0, right: sidePadding), size: .init(width: 0, height: 40))
        activityFieldsVC.view.anchor(top: buttonToggleView.bottomAnchor, leading: buttonToggleView.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: buttonToggleView.trailingAnchor)
        categoryFieldsVC.view.anchor(top: buttonToggleView.bottomAnchor, leading: buttonToggleView.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: buttonToggleView.trailingAnchor)
    }
    
}
