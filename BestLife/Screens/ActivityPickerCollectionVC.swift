//
//  ActivityPickerCollectionVC.swift
//  BestLife
//
//  Created by Mike Griffin on 4/8/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

protocol SelectActivityDelegate : class {
    func didSelectActivity(activity: Activity)
}

class ActivityPickerCollectionVC : UICollectionViewController, UICollectionViewDelegateFlowLayout, SelectHabitDelegate {
    weak var delegate : SelectActivityDelegate?
    var activitiesByCategory = [Category: [Activity]]()
    var singleCategoryAndActivities = [Category : [Activity]]()
    var sortedCategories = [Category]()
    let cellId = "cellId"
    
    let allHabitsButton : UIButton = {
        let button = UIButton()
        button.setTitle("Show All Habits", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleAllHabits), for: .touchUpInside)
        return button
    }()
    
    func didSelectHabit(habit: Habit) {
        delegate?.didSelectActivity(activity: habit as! Activity)
    }
    
    @objc fileprivate func handleAllHabits() {
        singleCategoryAndActivities = [Category : [Activity]]()
        collectionView.reloadData()
        allHabitsButton.isHidden = true
    }
    
    override func viewDidLoad() {
        setupCollectionView()
        setSortedCategories()
        addSubviews()
        setupConstraints()
    }
    
    fileprivate func setupCollectionView() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        collectionView.register(CategoryActivityCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate func setSortedCategories() {
        sortedCategories = Array(activitiesByCategory.keys.sorted(by: {$0.name! < $1.name!}))
    }
    
    fileprivate func addSubviews() {
        if !singleCategoryAndActivities.isEmpty {
            view.addSubview(allHabitsButton)
        }
    }
    
    fileprivate func setupConstraints() {
        if !singleCategoryAndActivities.isEmpty {
            allHabitsButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 30))
            collectionView.anchor(top: allHabitsButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !singleCategoryAndActivities.isEmpty {
            return 1
        } else {
            return sortedCategories.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryActivityCell
        let category = sortedCategories[indexPath.item]
        cell.category = category
        if !singleCategoryAndActivities.isEmpty {
            cell.activities = singleCategoryAndActivities.first?.value
        } else {
            cell.activities = activitiesByCategory[category]
        }
        cell.activitiesCollectionView.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedHeight = (CGFloat(activitiesByCategory[sortedCategories[indexPath.item]]!.count) * 30.0) + 40.0
        return CGSize(width: view.frame.width, height: estimatedHeight)
    }
}
