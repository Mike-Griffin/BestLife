//
//  HomeScreenVC.swift
//  BestLife
//
//  Created by Mike Griffin on 4/1/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class HomeScreenVC : UIViewController, GoalCellSelectedDelegate, LogSelectedUpcomingGoalDelegate, EventCellSelectedDelegate {

    let coreDataService = CoreDataService()
    
    let logActivityButton : UIButton = {
        let button = UIButton()
        button.setTitle("Log Activity", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleLogActivity), for: .touchUpInside)
        return button
    }()
    
    var logActivityScreen : LogActivityScreenVC = {
        let vc = LogActivityScreenVC()
        return vc
    }()
    
    let upcomingGoalsContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
//    let upcomingGoalsLabel : UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.text = "Upcoming Goal Deadlines"
//        label.font = UIFont.Theme.boldSectionTitle
//        return label
//    }()
    
    let upcomingGoalsButton : UIButton = {
        let button = UIButton()

        button.setAttributedTitle(NSAttributedString(string: "Upcoming Goals", attributes: [.font : UIFont.Theme.boldSectionTitle, .foregroundColor: UIColor.black]), for: .normal)
        
        // TODO Change this so the image is on the right side of the text
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.imageView?.tintColor = .black
        button.addTarget(self, action: #selector(handleUpcomingGoals), for: .touchUpInside)
        print(button.frame.width)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -500)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -200, bottom: 0, right: 0)
        return button
    }()
    
    let upcomingGoalsCollectionVC : UpcomingGoalsCollectionVC = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UpcomingGoalsCollectionVC(collectionViewLayout: layout)
        return cv
    }()
    
    let completedActivitiesContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let completedActivitiesButton : UIButton = {
        let button = UIButton()

        button.setAttributedTitle(NSAttributedString(string: "Completed Activities", attributes: [.font : UIFont.Theme.boldSectionTitle, .foregroundColor: UIColor.black]), for: .normal)
        
        // TODO Change this so the image is on the right side of the text
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.imageView?.tintColor = .black
        button.addTarget(self, action: #selector(handleCompletedActivities), for: .touchUpInside)
        print(button.frame.width)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -500)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -200, bottom: 0, right: 0)
        return button
    }()
    
    let completedEventsCollectionVC : CompletedEventsCollectionVC = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = CompletedEventsCollectionVC(collectionViewLayout: layout)
        return cv
    }()
    
    @objc func handleLogActivity() {
        navigationController?.pushViewController(logActivityScreen, animated: true)
    }
    
    @objc func handleCompletedActivities() {
        let vc = ViewCompletedActivitiesScreenVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleUpcomingGoals() {
        let vc = ViewUpcomingGoalsScreenVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectLogGoal(goal: Goal) {
        logActivityScreen = LogActivityScreenVC(goal: goal)
        navigationController?.pushViewController(logActivityScreen, animated: true)
    }
    
    func didSelectUpcomingGoalCell(goal: Goal) {
        let viewGoalVC = ViewGoalScreenVC(goal: goal)
        navigationController?.pushViewController(viewGoalVC, animated: true)
    }
    
    func didSelectCompletedEventCell(event: Event) {
        let viewEventVC = ViewEventScreenVC(event: event)
        navigationController?.pushViewController(viewEventVC, animated: true)
    }
    
    override func viewDidLoad() {
        setViewUI()
        configureChildren()
        addSubviews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let upcomingGoals = coreDataService.loadFutureGoals() {
            upcomingGoalsCollectionVC.upcomingGoals = upcomingGoals
            upcomingGoalsCollectionVC.collectionView.reloadData()
        } else {
            print("to do some empty upcoming goals state")
        }
        if let completedEvents = coreDataService.loadEvents() {
            completedEventsCollectionVC.completedEvents = completedEvents
            completedEventsCollectionVC.collectionView.reloadData()
        }
    }
    
    fileprivate func setViewUI() {
        view.backgroundColor = UIColor(r: 225, g: 225, b: 225)
    }
    
    fileprivate func configureChildren() {
        addChild(upcomingGoalsCollectionVC)
        upcomingGoalsCollectionVC.didMove(toParent: self)
        upcomingGoalsCollectionVC.selectDelegate = self
        upcomingGoalsCollectionVC.logDelegate = self
        addChild(completedEventsCollectionVC)
        completedEventsCollectionVC.didMove(toParent: self)
        completedEventsCollectionVC.delegate = self
        
        // TODO modify this to be display only the upcoming goals, not all the goals
        if let upcomingGoals = coreDataService.loadFutureGoals() {
            upcomingGoalsCollectionVC.upcomingGoals = upcomingGoals
            upcomingGoalsCollectionVC.collectionView.reloadData()
        } else {
            print("to do some empty upcoming goals state")
        }
        if let completedEvents = coreDataService.loadEvents() {
            completedEventsCollectionVC.completedEvents = completedEvents
            completedEventsCollectionVC.collectionView.reloadData()
        }
    }

    
    fileprivate func addSubviews() {
        view.addSubview(logActivityButton)
        view.addSubview(upcomingGoalsContainerView)
        upcomingGoalsContainerView.addSubview(upcomingGoalsButton)
        upcomingGoalsContainerView.addSubview(upcomingGoalsCollectionVC.view)
        view.addSubview(completedActivitiesContainerView)
        completedActivitiesContainerView.addSubview(completedActivitiesButton)
        completedActivitiesContainerView.addSubview(completedEventsCollectionVC.view)
    }
    
    fileprivate func setupConstraints() {
        let sidePadding = view.frame.width / 10
        let subViewHeight = view.frame.height / 3.4
        let containerViewHeight = view.frame.height / 2.7
        let containerViewWidth = view.frame.width * 0.9
        logActivityButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: sidePadding, bottom: 0, right: sidePadding), size: .init(width: 0, height: 40))
        upcomingGoalsContainerView.anchor(top: logActivityButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: containerViewWidth, height: containerViewHeight))
        completedActivitiesContainerView.anchor(top: upcomingGoalsContainerView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: containerViewWidth, height: containerViewHeight))
        
        upcomingGoalsButton.anchor(top: upcomingGoalsContainerView.topAnchor, leading: upcomingGoalsContainerView.leadingAnchor, bottom: nil, trailing: upcomingGoalsContainerView.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        upcomingGoalsCollectionVC.view.anchor(top: upcomingGoalsButton.bottomAnchor, leading: upcomingGoalsContainerView.leadingAnchor, bottom: nil, trailing: upcomingGoalsContainerView.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: subViewHeight))
        completedActivitiesButton.anchor(top: completedActivitiesContainerView.topAnchor, leading: completedActivitiesContainerView.leadingAnchor, bottom: nil, trailing: completedActivitiesContainerView.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        completedEventsCollectionVC.view.anchor(top: completedActivitiesButton.bottomAnchor, leading: completedActivitiesContainerView.leadingAnchor, bottom: nil, trailing: completedActivitiesContainerView.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: subViewHeight))
    }
    
}
