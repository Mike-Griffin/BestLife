//
//  ViewEventScreenVC.swift
//  BestLife
//
//  Created by Mike Griffin on 4/22/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class ViewEventScreenVC : UIViewController {
    let event : Event
    
    let activityNameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setViewUI()
        addSubviews()
        setupConstraints()
    }
    
    fileprivate func setViewUI() {
        view.backgroundColor = .white
        activityNameLabel.text = event.activity!.name
        var eventDate : Date
        if let startTime = event.startTime {
            print(startTime)
            eventDate = startTime
        }
        else {
            eventDate = event.logMoment!
        }
        dateLabel.text = "Activity logged \(eventDate.dateToString(format: "MMM d, yyyy"))"
    }
    
    fileprivate func addSubviews() {
        view.addSubview(activityNameLabel)
        view.addSubview(dateLabel)
    }
    
    fileprivate func setupConstraints() {
        activityNameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 24, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        dateLabel.anchor(top: activityNameLabel.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
    }
}
