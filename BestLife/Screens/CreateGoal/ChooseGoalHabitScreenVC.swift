//
//  ChooseGoalHabitScreenVC.swift
//  BestLife
//
//  Created by Mike Griffin on 4/2/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit
import CoreData

protocol SelectedGoalHabitDelegate: class {
    func didSelectHabit(habit: Habit, habitType: HabitType)
}

class ChooseGoalHabitScreenVC : UIViewController, SelectHabitDelegate, SelectActivityDelegate {

    
    weak var delegate : SelectedGoalHabitDelegate?
    let coreDataService = CoreDataService()
    var selectedHabitType = HabitType.Activity
    
    let buttonToggleView : ButtonToggleView = {
        let view = ButtonToggleView(firstButtonTitle: HabitType.Activity.rawValue, secondButtonTitle: HabitType.Category.rawValue)
        return view
    }()
    
    let categoryPicker : HabitPickerCollectionVC = {
        let layout = UICollectionViewFlowLayout()
        let cv = HabitPickerCollectionVC(collectionViewLayout: layout)
        return cv
    }()
    
    let activityPicker : ActivityPickerCollectionVC = {
        let layout = UICollectionViewFlowLayout()
        let cv = ActivityPickerCollectionVC(collectionViewLayout: layout)
        return cv
    }()
    
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
            categoryPicker.view.isHidden = true
            activityPicker.view.isHidden = false
        case HabitType.Category:
                buttonToggleView.updateSelected(selectedButton: buttonToggleView.secondButton, unSelectedButton: buttonToggleView.firstButton)
                categoryPicker.view.isHidden = false
                activityPicker.view.isHidden = true
        }
    }
    
    func didSelectActivity(activity: Activity) {
        navigationController?.popViewController(animated: true)
        delegate?.didSelectHabit(habit: activity, habitType: .Activity)
    }
    
    func didSelectHabit(habit: Habit) {
        navigationController?.popViewController(animated: true)
        delegate?.didSelectHabit(habit: habit, habitType: .Category)
    }
    
    override func viewDidLoad() {
        setViewUI()
        configureChildren()
        setupButtonToggleView()
        addSubviews()
        setupConstraints()
    }
    
    fileprivate func setViewUI() {
        view.backgroundColor = .white
    }
    
    fileprivate func setupButtonToggleView() {
        habitToggled()
        buttonToggleView.firstButton.addTarget(self, action: #selector(handleActivitySelectButton), for: .touchUpInside)
        buttonToggleView.secondButton.addTarget(self, action: #selector(handleCategorySelectButton), for: .touchUpInside)
    }
    
    fileprivate func configureChildren(){
        addChild(categoryPicker)
        categoryPicker.didMove(toParent: self)
        categoryPicker.delegate = self
        loadCategories()
        addChild(activityPicker)
        activityPicker.didMove(toParent: self)
        activityPicker.delegate = self
        loadActivities()
    }
    
    fileprivate func loadCategories() {
        categoryPicker.habits = coreDataService.loadCategories()
    }
    
    fileprivate func loadActivities() {
        //var activitiesByCategory = [Category: [Activity]]()
        activityPicker.activitiesByCategory = coreDataService.loadActivitySplitByCategory()
    }
    
    fileprivate func addSubviews() {
        view.addSubview(buttonToggleView)
        view.addSubview(categoryPicker.view)
        view.addSubview(activityPicker.view)
    }
    
    fileprivate func setupConstraints() {
        let sidePadding = view.frame.width / 10

        buttonToggleView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: sidePadding, bottom: 0, right: sidePadding), size: .init(width: 0, height: 40) )
        categoryPicker.view.anchor(top: buttonToggleView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: sidePadding + 16, bottom: 16, right: sidePadding + 16))
        activityPicker.view.anchor(top: buttonToggleView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: sidePadding + 16, bottom: 16, right: sidePadding + 16))
    }
}
