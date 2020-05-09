//
//  CategoryFieldsViewController.swift
//  BestLife
//
//  Created by Mike Griffin on 4/3/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class CategoryFieldsVC : UIViewController, ColorPickerDelegate {
    var selectedColor: String?
    let coreDataService = CoreDataService()

    let nameTextField : PlaceholderAnimatedTextField = {
        let textField = PlaceholderAnimatedTextField(placeholder: "Category Name")
        return textField
    }()
    
    let colorPickerCV : ColorPickerCollectionVC = {
        let layout = UICollectionViewFlowLayout()
        let cv = ColorPickerCollectionVC(collectionViewLayout: layout)
        return cv
    }()
    
    let submitButton : UIButton = {
        let button = UIButton()
        button.setTitle("Create Category", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSubmit() {
        if let name = nameTextField.text, let color = selectedColor {
            coreDataService.saveCategory(name: name, color: color)
            tabBarController?.selectedIndex = 0
            clearFields()
            
            // let categories = coreDataService.loadCategories()
        } else {
            if nameTextField.text == nil {
                print("name is nil")
            }
            if selectedColor == nil {
                print("color is nil")
            }
        }
    }
    
    fileprivate func clearFields() {
        colorPickerCV.collectionView.deselectAllItems()
        selectedColor = nil
        nameTextField.text = ""
        
    }

    override func viewDidLoad() {
        setViewUI()
        configureChildren()
        addSubviews()
        setupConstraints()
    }
    
    func colorSelected(colorHex: String) {
        self.selectedColor = colorHex
    }
    
    fileprivate func setViewUI() {
        view.backgroundColor = .white
    }
    
    fileprivate func configureChildren() {
        self.addChild(colorPickerCV)
        colorPickerCV.delegate = self
    }
    
    fileprivate func addSubviews() {
        view.addSubview(nameTextField)
        view.addSubview(colorPickerCV.view)
        view.addSubview(submitButton)
    }
    
    fileprivate func setupConstraints() {
        nameTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 24, bottom: 0, right: 24), size: .init(width: 0, height: 50))
        colorPickerCV.view.anchor(top: nameTextField.bottomAnchor, leading: nameTextField.leadingAnchor, bottom: nil, trailing: nameTextField.trailingAnchor, padding: .init(top: 16, left: 32, bottom: 0, right: 32), size: .init(width: 0, height: 200))
        submitButton.anchor(top: colorPickerCV.view.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 200, height: 50))
        submitButton.anchorCenter(centerX: view.centerXAnchor, centerY: nil)
    }

}
