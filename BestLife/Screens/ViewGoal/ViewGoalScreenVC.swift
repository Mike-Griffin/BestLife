//
//  ViewGoalScreenVC.swift
//  BestLife
//
//  Created by Mike Griffin on 4/14/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class ViewGoalScreenVC : UIViewController {
    let goal: Goal
    
    var activityView : ActivityGoalView?
    var categoryView : CategoryGoalView?
    
    let headerView : UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var detailsView = GoalDetailsView(goal: goal)
    
    let logButton : UIButton = {
        let button = UIButton()
        button.setTitle("Log", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleLogButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLogButton() {
        navigationController?.pushViewController(LogActivityScreenVC(goal: goal), animated: true)
    }
    
    init(goal: Goal) {
        self.goal = goal
        super.init(nibName: nil, bundle: nil)
        setViewUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        addSubviews()
        setupConstraints()
    }
    
    fileprivate func setViewUI() {
        view.backgroundColor = .white

    }
    
    fileprivate func addSubviews() {
        if let activity = goal.activity {
            activityView = ActivityGoalView(activity: activity)
            headerView.addSubview(activityView!)
        }
        if let category = goal.category {
            categoryView = CategoryGoalView(category: category)
            headerView.addSubview(categoryView!)
        }
        view.addSubview(headerView)
        view.addSubview(detailsView)
        view.addSubview(logButton)
    }
    
    fileprivate func setupConstraints() {
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 100))
        if let activityView = activityView {
            activityView.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, trailing: headerView.trailingAnchor)
        }
        if let categoryView = categoryView {
            categoryView.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, trailing: headerView.trailingAnchor)
        }
        detailsView.anchor(top: headerView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 60))
        logButton.anchor(top: detailsView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
    }
}
