//
//  ViewCompletedActivitiesScreenVC.swift
//  BestLife
//
//  Created by Mike Griffin on 5/1/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class ViewCompletedActivitiesScreenVC : UIViewController, EventCellSelectedDelegate {

    
    let coreDataService = CoreDataService()

    let filterCriteriaView : FilterCriteriaView = {
        let view = FilterCriteriaView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let completedEventsCollectionVC : CompletedEventsCollectionVC = {
        let layout = UICollectionViewFlowLayout()
        let vc = CompletedEventsCollectionVC(collectionViewLayout: layout)
        return vc
    }()
    
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
    
    fileprivate func setViewUI() {
        view.backgroundColor = .white
        title = "Completed Activities"
    }
    
    fileprivate func configureChildren() {
        addChild(completedEventsCollectionVC)
        completedEventsCollectionVC.didMove(toParent: self)
        completedEventsCollectionVC.sizeMode = .big
        if let completedEvents = coreDataService.loadEvents() {
            completedEventsCollectionVC.completedEvents = completedEvents
            completedEventsCollectionVC.collectionView.reloadData()
        }
        completedEventsCollectionVC.delegate = self
    }
    
    fileprivate func addSubviews() {
        view.addSubview(filterCriteriaView)
        view.addSubview(completedEventsCollectionVC.view)
    }
    
    fileprivate func setupConstraints() {
        filterCriteriaView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        filterCriteriaView.anchorRelativeHeight(height: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.12)
        completedEventsCollectionVC.view.anchor(top: filterCriteriaView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }

}
