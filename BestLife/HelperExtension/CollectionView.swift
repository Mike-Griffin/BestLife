//
//  CollectionView.swift
//  BestLife
//
//  Created by Mike Griffin on 4/12/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

extension UICollectionView {

    func deselectAllItems() {
        self.indexPathsForSelectedItems?
            .forEach { self.deselectItem(at: $0, animated: false) }
        //if let selectedItems = self.indexPathsForSelectedItems {
//            for indexPath in selectedItems {
//                deselectItem(at: indexPath, animated:true)
//            }
//        }
    }
}
