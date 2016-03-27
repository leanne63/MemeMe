//
//  UICollectionViewExtensions.swift
//  MemeMe
//
//  Created by leanne on 3/25/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit


extension UICollectionView {
	
	func constraintForIdentifier(identifier: String) -> NSLayoutConstraint? {
		
		for constraint: NSLayoutConstraint in self.constraints {
			
			if(constraint.identifier == identifier) {
				return constraint
			}
		}
		
		// if we're here, no constraint was found
		return nil
	}
}
