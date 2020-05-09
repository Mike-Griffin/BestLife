//
//  HabitPickerCollectionVC.swift
//  BestLife
//
//  Created by Mike Griffin on 4/2/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//
import UIKit

protocol SelectHabitDelegate : class {
    func didSelectHabit(habit: Habit)
}

class HabitPickerCollectionVC : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var habits = [Habit]()
    weak var delegate : SelectHabitDelegate?
    
    override func viewDidLoad() {
        collectionView.backgroundColor = .white
        collectionView.register(HabitPickerCell.self, forCellWithReuseIdentifier: Constants.cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellId, for: indexPath) as! HabitPickerCell
        cell.habit = habits[indexPath.item]
//cell.backgroundColor = .yellow
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectHabit(habit: habits[indexPath.item])
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return habits.count
    }
}
