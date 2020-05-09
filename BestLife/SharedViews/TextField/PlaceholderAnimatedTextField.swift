//
//  PlaceholderAnimatedTextField.swift
//  BestLife
//
//  Created by Mike Griffin on 4/2/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class PlaceholderAnimatedTextField : UITextField, UITextFieldDelegate {
    var placeholderVal: String
    var placeholderTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.Theme.systemSmall
        return label
    }()
    
    let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    required init(placeholder: String) {
        self.placeholderVal = placeholder
        self.placeholderTitle.text = placeholder
        super.init(frame: .zero)
        delegate = self
        autocorrectionType = .no
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        self.textColor = .black
        configurePlaceholderTitle()
        configureUnderline()
    }
    
    func configurePlaceholderTitle() {
        self.addSubview(placeholderTitle)
        placeholderTitle.isHidden = true
        placeholderTitle.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: 100, height: 10))
    }
    
    func configureUnderline() {
        addSubview(underLine)
        underLine.anchor(top: nil, leading: safeAreaLayoutGuide.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 1))
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5, dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5, dy: 10)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        placeholderTitle.isHidden = false
        self.placeholder = nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(text?.count == 0) {
            placeholderTitle.isHidden = true
            placeholder = placeholderVal

        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
