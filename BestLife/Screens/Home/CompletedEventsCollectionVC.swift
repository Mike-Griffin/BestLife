//
//  CompletedEventsCollectionVC.swift
//  BestLife
//
//  Created by Mike Griffin on 4/11/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

protocol EventCellSelectedDelegate : class {
    func didSelectCompletedEventCell(event: Event)
}

class CompletedEventsCollectionVC : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    var completedEvents: [Event] = []
    weak var delegate : EventCellSelectedDelegate?
    var sizeMode : SizeMode = .small

    override func viewDidLoad() {
        collectionView.register(CompletedEventCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .white
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CompletedEventCell
        //cell.backgroundColor = .red
        print(indexPath.row)
        print(completedEvents[indexPath.row])
        cell.event = completedEvents[indexPath.row]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return completedEvents.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = sizeMode == .small ? (view.frame.height * 0.3) : (view.frame.height * 0.1)
        return CGSize(width: view.frame.width * 0.8, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCompletedEventCell(event: completedEvents[indexPath.item])
    }
}
