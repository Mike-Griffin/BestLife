//
//  ActivityFieldsViewController.swift
//  BestLife
//
//  Created by Mike Griffin on 4/3/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

class ActivityFieldsVC : UIViewController, ColorPickerDelegate, SelectHabitDelegate {
    let coreDataService = CoreDataService()
    var selectedCategory : Category?
    var selectedColor: String?

//    let nameTextField : PlaceholderAnimatedTextField = {
//        let textField = PlaceholderAnimatedTextField(placeholder: "Activity Name")
//        return textField
//    }()
    
    let activityNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Activity Name:"
        label.font = UIFont.Theme.boldSmall
        label.textColor = .black
        return label
    }()
    
    let nameTextField : UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.attributedPlaceholder = NSAttributedString(string: "Ex. Running, Read Chapter",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, .font : UIFont.Theme.systemMedium])
        textField.font = UIFont.Theme.systemMedium
        textField.textColor = .black
        textField.backgroundColor = UIColor(r: 225, g: 225, b: 225)
        textField.layer.cornerRadius = 15
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 2.0))
        textField.leftViewMode = .always
        return textField
    }()
    
    let categoryLabel : UILabel = {
        let label = UILabel()
        label.text = "Category:"
        label.font = UIFont.Theme.boldSmall
        label.textColor = .black
        return label
    }()
    
    let chooseCategoryButton : UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "None", attributes: [.font : UIFont.Theme.boldSmall, .foregroundColor: UIColor(hex: "#004d99")!]), for: .normal)
        button.addTarget(self, action: #selector(handleChooseCategory), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    let  categoryPickerCV : HabitPickerCollectionVC = {
        let layout = UICollectionViewFlowLayout()
        let cv = HabitPickerCollectionVC(collectionViewLayout: layout)
        return cv
    }()
    
    let chooseColorLabel : UILabel = {
        let label = UILabel()
        label.text = "Choose Color:"
        label.font = UIFont.Theme.boldSmall
        label.textColor = .black
        return label
    }()
    
    let colorPickerCV : ColorPickerCollectionVC = {
        let layout = UICollectionViewFlowLayout()
        let cv = ColorPickerCollectionVC(collectionViewLayout: layout)
        return cv
    }()
    
    let submitButton : UIButton = {
        let button = UIButton()
        button.setTitle("Create Activity", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChooseCategory() {
        view.endEditing(true)
        categoryPickerCV.delegate = self
        navigationController?.pushViewController(categoryPickerCV, animated: true)
    }
    
    @objc func handleSubmit() {
        if let name = nameTextField.text, let color = selectedColor {
            if name == "" {
                let nameError = Alert.errorAlert(title: "Error", message: "Please enter a name")
                self.present(nameError, animated: true)
            }
            else if let selectedCategory = selectedCategory {
                coreDataService.saveActivity(name: name, color: color, category: selectedCategory)
                clearFields()
            }
            else {
                print("do something to verify create an uncategorized event")
            }
            
        } else {
            if nameTextField.text == nil {
                let nameError = Alert.errorAlert(title: "Error", message: "Please enter a name")
                self.present(nameError, animated: true)
            }
            if selectedColor == nil {
                let colorError = Alert.errorAlert(title: "Error", message: "Please select a color")
                self.present(colorError, animated: true)
            }
        }

    }
    
    fileprivate func clearFields() {
        self.selectedCategory = nil
        colorPickerCV.collectionView.deselectAllItems()
        selectedColor = nil
        nameTextField.text = ""
        tabBarController?.selectedIndex = 0
        chooseCategoryButton.setTitle("Choose Category", for: .normal)
    }
    
    func didSelectHabit(habit: Habit) {
        chooseCategoryButton.setAttributedTitle(NSAttributedString(string: habit.name!, attributes: [.font : UIFont.Theme.boldSmall, .foregroundColor: UIColor(hex: "#004d99")!]), for: .normal)
        navigationController?.popViewController(animated: true)
        selectedCategory = (habit as! Category)
    }
    
    override func viewDidLoad() {
        setViewUI()
        configureChildren()
        addSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureCategories()
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
        view.addSubview(activityNameLabel)
        view.addSubview(nameTextField)
        view.addSubview(categoryLabel)
        view.addSubview(chooseCategoryButton)
        view.addSubview(chooseColorLabel)
        view.addSubview(colorPickerCV.view)
        view.addSubview(submitButton)
    }
    
    fileprivate func setupConstraints() {
        activityNameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 0), size: .init(width: 200, height: 30))
        nameTextField.anchor(top: activityNameLabel.bottomAnchor, leading: activityNameLabel.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 24), size: .init(width: 0, height: 30))
        categoryLabel.anchor(top: nameTextField.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 0))
        chooseCategoryButton.anchor(top: categoryLabel.bottomAnchor, leading: categoryLabel.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 200, height: 30))
        chooseColorLabel.anchor(top: chooseCategoryButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 0))
        colorPickerCV.view.anchor(top: chooseColorLabel.bottomAnchor, leading: chooseColorLabel.leadingAnchor, bottom: nil, trailing: nameTextField.trailingAnchor, padding: .init(top: 16, left: 8, bottom: 0, right: 0))
        colorPickerCV.view.anchorRelativeWidth(width: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.55)
        colorPickerCV.view.anchorRelativeHeight(height: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4)
        submitButton.anchor(top: colorPickerCV.view.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 200, height: 50))
        submitButton.anchorCenter(centerX: view.centerXAnchor, centerY: nil)
    }
    
    fileprivate func configureCategories() {
        categoryPickerCV.habits = coreDataService.loadCategories()
        categoryPickerCV.collectionView.reloadData()
    }

}
