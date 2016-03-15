//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by leanne on 3/11/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {

	// MARK: - Properties
	
	let collectionCellReuseIdentifier = "reusableCollectionCell"
	
	
	// MARK: - Collection View Controller Overrides
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let numMemes = AppDelegate.memes.count
		let isEmpty = (numMemes == 0)
		
		setUpCollectionViewBackground(isEmpty)
		
		// reload collection to ensure all memes are displayed
		collectionView?.reloadData()
	}

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if segue.identifier == "collectionViewSegueToDetail" {
			let controller = segue.destinationViewController as! DetailViewController
			let cellImageView = (sender as! UICollectionViewCell).viewWithTag(1) as! UIImageView
			controller.selectedImage = cellImageView.image
		}
    }
	
	
	// MARK: Collection View Data Source

	// using default number of sections (1), so no override for numberOfSections
	
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		let numItems = AppDelegate.memes.count
		
		return numItems
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellReuseIdentifier, forIndexPath: indexPath)
		
		let cellImageView = cell.viewWithTag(1) as! UIImageView
		
		cellImageView.image = AppDelegate.memes[indexPath.row].memedImage
		
        return cell
    }

	
	// MARK: - Utility Functions
	
	func setUpCollectionViewBackground(isEmpty: Bool) {
		
		guard let theCollectionView = collectionView else {
			return
		}
		
		// code modified from:
		// iOS Programming 101: Implementing Pull-to-Refresh and Handling Empty Table
		//	Simon Ng, 11 July 2014
		//	http://www.appcoda.com/pull-to-refresh-uitableview-empty/
		
		let emptyMessageText = "No memes sent yet!\nPress + to create a new meme\nand share it."
		let fontName = "Palatino-Italic"
		let fontSize: CGFloat = 20.0
		
		if !isEmpty {
			if theCollectionView.backgroundView != nil {
				theCollectionView.backgroundView = nil
			}
		}
		else {
			if theCollectionView.backgroundView == nil {
				let emptyMessageLabel = UILabel(frame: CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
				emptyMessageLabel.text = emptyMessageText
				emptyMessageLabel.numberOfLines = 0
				emptyMessageLabel.font = UIFont(name: fontName, size: fontSize)
				emptyMessageLabel.textAlignment = .Center
				emptyMessageLabel.sizeToFit()
				
				theCollectionView.backgroundView = emptyMessageLabel
			}
		}
	}
	


}
