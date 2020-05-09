//
//  LogActivityScreenVC.swift
//  BestLife
//
//  Created by Mike Griffin on 4/8/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class LogActivityScreenVC : UIViewController, SelectActivityDelegate, TimerActivitySaveDelegate {
    let coreDataService = CoreDataService()
    let goal : Goal?
    
    let chooseActivityButton : UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Choose Activity", for: .normal)
        button.addTarget(self, action: #selector(handleChooseActivity), for: .touchUpInside)
        return button
    }()
    
    let showTimerButton : UIButton = {
        let button = UIButton()
        button.setTitle("Timer Mode", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleShowTimer), for: .touchUpInside)
        return button
    }()
    
    let showDetailsFormButton : UIButton = {
        let button = UIButton()
        button.setTitle("Set Details", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    let logWithoutTimeDetailsButton : UIButton = {
        let button = UIButton()
        button.setTitle("Just Log It", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleLogWithoutDetails), for: .touchUpInside)
        return button
    }()
    
    let activityPicker : ActivityPickerCollectionVC = {
        let layout = UICollectionViewFlowLayout()
        let cv = ActivityPickerCollectionVC(collectionViewLayout: layout)
        return cv
    }()
    
    let timerView = TimerView()
    
    @objc func handleChooseActivity() {
        navigationController?.pushViewController(activityPicker, animated: true)
    }
    
    @objc func handleShowTimer() {
        showDetailsFormButton.isHidden = true
        showTimerButton.isHidden = true
        logWithoutTimeDetailsButton.isHidden = true
        timerView.isHidden = false
    }
    
    @objc func handleLogWithoutDetails() {
        if let selectedActivity = selectedActivity {
            coreDataService.saveEvent(activity: selectedActivity, startTime: nil, endTime: nil, duration: nil)
            navigationController?.popViewController(animated: true)
        }
    }
    
    var selectedActivity : Activity?
    
    func didSelectActivity(activity: Activity) {
        selectedActivity = activity
        navigationController?.popViewController(animated: true)
        showDetailsFormButton.isHidden = false
        showTimerButton.isHidden = false
        logWithoutTimeDetailsButton.isHidden = false
        chooseActivityButton.setTitle("Log Activity: \(activity.name!)", for: .normal)
        timerView.activity = activity
    }
    
    fileprivate func categorySelected(_ category: Category) {
        chooseActivityButton.setTitle("Choose Activity from \(category.name!)", for: .normal)
        // TODO change activity
        let activities = coreDataService.loadSingleCategoryActivities(category)
        activityPicker.singleCategoryAndActivities = [category : activities]
    }
    
    func didSaveTimerActivity(startTime: Date, endTime: Date, duration: Int) {
        if let selectedActivity = selectedActivity {
            coreDataService.saveEvent(activity: selectedActivity, startTime: startTime, endTime: endTime, duration: duration)
            navigationController?.popViewController(animated: true)
        }
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, goal: Goal?) {
        self.goal = goal
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.goal = nil
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    convenience init(goal: Goal?) {
        self.init(nibName: nil, bundle: nil, goal: goal)
        if let activity = goal?.activity {
            didSelectActivity(activity: activity)
        }
        if let category = goal?.category {
            categorySelected(category)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setViewUI()
        configureActivityPicker()
        // TODO consider a new name for this
        configureSubForms()
        addSubviews()
        setupConstraints()
        if goal == nil {
            hideButtons()
        }
        hideViews()
    }
    
    fileprivate func setViewUI() {
        view.backgroundColor = .white
        self.title = "Log Activity"
    }
    
    fileprivate func configureActivityPicker() {
        activityPicker.activitiesByCategory = coreDataService.loadActivitySplitByCategory()
        activityPicker.delegate = self
    }
    
    fileprivate func configureSubForms() {
        timerView.delegate = self
    }
    
    fileprivate func addSubviews() {
        view.addSubview(chooseActivityButton)
        view.addSubview(showTimerButton)
        view.addSubview(showDetailsFormButton)
        view.addSubview(logWithoutTimeDetailsButton)
        view.addSubview(timerView)
    }
    
    fileprivate func setupConstraints() {
        chooseActivityButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 24, left: 24, bottom: 0, right: 24), size: .init(width: 0, height: 40))
        showTimerButton.anchor(top: chooseActivityButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 32, bottom: 0, right: 32), size: .init(width: 0, height: 30))
        showDetailsFormButton.anchor(top: showTimerButton.bottomAnchor, leading: showTimerButton.leadingAnchor, bottom: nil, trailing: showTimerButton.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0) ,size: .init(width: 0, height: 30))
        logWithoutTimeDetailsButton.anchor(top: showDetailsFormButton.bottomAnchor, leading: showTimerButton.leadingAnchor, bottom: nil, trailing: showTimerButton.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        timerView.anchor(top: chooseActivityButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 32, left: 0, bottom: 0, right: 0))
        timerView.anchorRelativeHeight(height: view.safeAreaLayoutGuide.heightAnchor)
    }
    
    fileprivate func hideButtons() {
        showTimerButton.isHidden = true
        showDetailsFormButton.isHidden = true
        logWithoutTimeDetailsButton.isHidden = true
    }
    
    fileprivate func hideViews() {
        timerView.isHidden = true
    }
}
