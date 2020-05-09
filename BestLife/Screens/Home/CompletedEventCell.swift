//
//  CompletedEventCell.swift
//  BestLife
//
//  Created by Mike Griffin on 4/11/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class CompletedEventCell: UICollectionViewCell {
    let activityNameLabel : UILabel = {
        let label = UILabel()
        // probably bold the font
        label.font = UIFont.Theme.boldCellTitle
        label.textColor = .black
        //label.text = "Activity Data Error"
        return label
    }()
    
    let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.Theme.cellSubheading
        return label
    }()
    
    let dateTimeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.Theme.cellSubheading
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    let colorCircle : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    

    
    var event : Event? {
        didSet {
            if let activity = event?.activity {
                setActivityData(activity)
            }
            if let event = event {
                displayDate(event.logMoment!)
                //self.dateTimeLabel.text = event.logMoment.hoursMinute()
            }
        }
    }
    
    fileprivate func displayDate(_ moment: Date){
        if(moment.dateIsToday()) {
            dateTimeLabel.text = "Today at \(moment.dateToString(format: "h:mm a"))"
        }
        else if (moment.dateIsYesterday()) {
            dateTimeLabel.text = "Yesterday at \(moment.dateToString(format: "h:mm a"))"
        }
        else if (moment.dateIsWithinWeek()) {
            dateTimeLabel.text = "\(moment.dateToString(format: "EEEE"))"
        }
        else {
            dateTimeLabel.text = moment.dateToString(format: "MMM d, yyyy")
        }
    }
    
    fileprivate func setActivityData(_ activity: Activity) {
            self.activityNameLabel.text = activity.name
            self.colorCircle.backgroundColor = UIColor(hex: activity.hex!)
            if let category = activity.category {
                self.categoryNameLabel.text = category.name
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 5
    }
    
    fileprivate func addSubviews() {
        addSubview(activityNameLabel)
        addSubview(categoryNameLabel)
        addSubview(dateTimeLabel)
        addSubview(colorCircle)
    }
    
    fileprivate func setupConstraints() {
        let rowHeight : CGFloat = frame.height / 2.0
        colorCircle.anchor(top: nil, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 20, height: 20))
        colorCircle.anchorCenter(centerX: nil, centerY: safeAreaLayoutGuide.centerYAnchor)
        activityNameLabel.anchor(top: safeAreaLayoutGuide.topAnchor, leading: colorCircle.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 4, left: 16, bottom: 0, right: 0), size: .init(width: 200, height: rowHeight))
        categoryNameLabel.anchor(top: nil, leading: activityNameLabel.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 4, right: 0), size: .init(width: 120, height: rowHeight))
        dateTimeLabel.anchor(top: categoryNameLabel.topAnchor, leading: categoryNameLabel.trailingAnchor, bottom: categoryNameLabel.bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
