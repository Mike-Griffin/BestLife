//
//  DatePickerLauncher.swift
//  BestLife
//
//  Created by Mike Griffin on 4/7/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class DatePickerLauncher : UIViewController {
    let datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.backgroundColor = .white
        return datePicker
    }()
    
    
    lazy var slideUpLauncher = SlideUpLauncher(subview: datePicker, height: 220)
    
    
    func showDatePicker() {
        slideUpLauncher.showSlideUpView()
    }
}
