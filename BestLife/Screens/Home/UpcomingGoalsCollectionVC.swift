//
//  UpcomingGoalsCollectionVC.swift
//  BestLife
//
//  Created by Mike Griffin on 4/7/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

protocol GoalCellSelectedDelegate : class {
    func didSelectUpcomingGoalCell(goal: Goal)
}

protocol LogSelectedUpcomingGoalDelegate : class {
    func didSelectLogGoal(goal: Goal)
}

class UpcomingGoalsCollectionVC : UICollectionViewController, UICollectionViewDelegateFlowLayout,  LogUpcomingGoalDelegate {

    
    let cellId = "cellId"
    var upcomingGoals = [Goal]()
    weak var selectDelegate : GoalCellSelectedDelegate?
    weak var logDelegate : LogSelectedUpcomingGoalDelegate?
    
    func didSelectLogGoal(goal: Goal) {
        logDelegate?.didSelectLogGoal(goal: goal)
    }
    
    override func viewDidLoad() {
        collectionView.register(UpcomingGoalCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .white
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upcomingGoals.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UpcomingGoalCell
        cell.delegate = self
        cell.goal = upcomingGoals[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 64, height: view.frame.height * 0.3)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectDelegate?.didSelectUpcomingGoalCell(goal: upcomingGoals[indexPath.item])
    }
}
