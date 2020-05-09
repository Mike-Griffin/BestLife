//
//  MenuLauncher.swift
//  BestLife
//
//  Created by Mike Griffin on 4/6/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

protocol MenuOptionSelectedDelegate : class {
    func didSelectOption(option: String)
}

class MenuLauncher : NSObject {
    let cellId = "cellId"
    weak var delegate : MenuOptionSelectedDelegate?
    let options : [String]
    
    lazy var slideUpLauncher = SlideUpLauncher(subview: selectMenu, height: (CGFloat(options.count) * 40.0) + 20.0)
    
    init(options: [String]) {
        self.options = options
        super.init()
        
        selectMenu.delegate = self
        selectMenu.dataSource = self
        
        selectMenu.register(MenuSelectCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    lazy var selectMenu : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let vc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vc.backgroundColor = .white
        return vc
    }()
    
    func showMenu() {
        slideUpLauncher.showSlideUpView()
    }
    

}

extension MenuLauncher : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .top)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuSelectCell
        cell.option = options[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: selectMenu.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectOption(option: options[indexPath.item])
        slideUpLauncher.handleDismiss()
    }
    
}
