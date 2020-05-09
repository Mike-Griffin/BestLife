//
//  CreateGoalScreenVC.swift
//  BestLife
//
//  Created by Mike Griffin on 4/1/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class CreateGoalScreenVC : UIViewController, SelectedGoalHabitDelegate {

    var selectedHabit : Habit?
    var selectedHabitType : HabitType?
    var selectedGoalType : GoalType = GoalType.Streak
    let coreDataService = CoreDataService()
    
    let chooseGoalHabitButton : UIButton = {
        let button = UIButton()
        button.setTitle("What Do You Want to Set a Goal For?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleGoalItemButton), for: .touchUpInside)
        return button
    }()
    
    let selectedCategoryLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let buttonToggleView : ButtonToggleView = {
        let view = ButtonToggleView(firstButtonTitle: GoalType.Streak.rawValue, secondButtonTitle: GoalType.Deadline.rawValue)
        return view
    }()
    
    let streakFieldsViewController : StreakFieldsVC = {
        let vc = StreakFieldsVC()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    let deadlineFieldsViewController : DeadlineFieldsVC = {
        let vc = DeadlineFieldsVC()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    let submitButton : UIButton = {
        let button = UIButton()
        button.setTitle("Create Goal", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleStreakSelectButton() {
        selectedGoalType = GoalType.Streak
        goalTypeToggled()
    }
    
    @objc fileprivate func handleDeadlineSelectButton() {
        selectedGoalType = GoalType.Deadline
        goalTypeToggled()
    }
    
    fileprivate func goalTypeToggled() {
        switch selectedGoalType {
        case GoalType.Streak:
            buttonToggleView.updateSelected(selectedButton: buttonToggleView.firstButton, unSelectedButton: buttonToggleView.secondButton)
            streakFieldsViewController.view.isHidden = false
            deadlineFieldsViewController.view.isHidden = true
        case GoalType.Deadline:
                buttonToggleView.updateSelected(selectedButton: buttonToggleView.secondButton, unSelectedButton: buttonToggleView.firstButton)
                streakFieldsViewController.view.isHidden = true
                deadlineFieldsViewController.view.isHidden = false
        }
    }
    
    @objc fileprivate func handleGoalItemButton() {
        if selectedHabit == nil {
            let chooseGoalHabitScreenVC = ChooseGoalHabitScreenVC()
            chooseGoalHabitScreenVC.delegate = self
            navigationController?.pushViewController(chooseGoalHabitScreenVC, animated: true)
        }
    }
    
    @objc fileprivate func handleSubmit() {
        switch selectedGoalType {
        case .Streak:
            if let selectedHabit = selectedHabit, let duration = streakFieldsViewController.numberTextField.text  {
                if let duration = Int(duration) {
                    coreDataService.saveStreakGoal(duration: duration, timespan: streakFieldsViewController.selectedTimeSpan.rawValue, habit: selectedHabit)
                    goalCreated()
                }
            }
        case .Deadline:
            let deadlineDate = deadlineFieldsViewController.datePickerLauncher.datePicker.date.startOfDay()
            if let selectedHabit = selectedHabit {
                coreDataService.saveDeadlineGoal(deadline: deadlineDate, habit: selectedHabit)
                goalCreated()
            }
            else {
                print("habit is nil")
            }
        }
        
    }
    
    fileprivate func goalCreated() {
        let alert = Alert.infoAlert(message: "Goal Created")
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    func didSelectHabit(habit: Habit, habitType: HabitType) {
        selectedHabit = habit
        selectedHabitType = habitType
        chooseGoalHabitButton.setTitle("Set a Goal For", for: .normal)
        selectedCategoryLabel.text = "\(habit.name!) \(habitType.rawValue)"
        selectedCategoryLabel.isHidden = false
        buttonToggleView.isHidden = false
        submitButton.isHidden = false
        streakFieldsViewController.habitType = habitType
        deadlineFieldsViewController.habitType = habitType
        goalTypeToggled()
    }
    
    override func viewDidLoad() {
        setViewUI()
        configureChildren()
        addSubviews()
        setupButtonToggleView()
        setupConstraints()
        hideViews()
    }
    
    fileprivate func setViewUI() {
        view.backgroundColor = .white
        self.title = "Create Goal"
    }
    
    fileprivate func configureChildren() {
        addChild(streakFieldsViewController)
        addChild(deadlineFieldsViewController)
    }
    
    fileprivate func addSubviews() {
        view.addSubview(chooseGoalHabitButton)
        view.addSubview(selectedCategoryLabel)
        view.addSubview(buttonToggleView)
        view.addSubview(streakFieldsViewController.view)
        view.addSubview(deadlineFieldsViewController.view)
        view.addSubview(submitButton)
    }
    
    fileprivate func setupButtonToggleView() {
        goalTypeToggled()
        buttonToggleView.firstButton.addTarget(self, action: #selector(handleStreakSelectButton), for: .touchUpInside)
        buttonToggleView.secondButton.addTarget(self, action: #selector(handleDeadlineSelectButton), for: .touchUpInside)
    }
    
    fileprivate func setupConstraints() {
        let sidePadding = view.frame.width / 10
        
        chooseGoalHabitButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 30))
        selectedCategoryLabel.anchor(top: chooseGoalHabitButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        buttonToggleView.anchor(top: selectedCategoryLabel.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: sidePadding, bottom: 0, right: sidePadding), size: .init(width: 0, height: 40))
        streakFieldsViewController.view.anchor(top: buttonToggleView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 200))
        deadlineFieldsViewController.view.anchor(top: buttonToggleView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 200))
        submitButton.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: sidePadding, bottom: 40, right: sidePadding), size: .init(width: 0, height: 40))
    }
    
    fileprivate func hideViews() {
        selectedCategoryLabel.isHidden = true
        buttonToggleView.isHidden = true
        streakFieldsViewController.view.isHidden = true
        deadlineFieldsViewController.view.isHidden = true
        submitButton.isHidden = true
    }
}
