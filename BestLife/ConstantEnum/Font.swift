//
//  Font.swift
//  BestLife
//
//  Created by Mike Griffin on 4/2/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

extension UIFont {
    enum Theme {
        static var systemSmall : UIFont {
            return  UIFont.systemFont(ofSize: 10)
        }
        
        static var systemMedium : UIFont {
            return UIFont.systemFont(ofSize: 12)
        }
        
        static var boldSmall : UIFont {
            return UIFont.boldSystemFont(ofSize: 14)
        }
        
        static var boldCellTitle : UIFont {
            return UIFont.boldSystemFont(ofSize: 16)
        }
        
        static var boldSectionTitle : UIFont {
            return UIFont.boldSystemFont(ofSize: 18)
        }
        
        static var systemLarge : UIFont {
            return UIFont.systemFont(ofSize: 38)
        }
        
        static var cellSubheading : UIFont {
            return UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        }


    }
}
