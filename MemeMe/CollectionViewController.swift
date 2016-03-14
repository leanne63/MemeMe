//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by leanne on 3/11/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit

// TODO: resize collection view cell (must define custom cell???)
// TODO: collection view delete - how?
// TODO: edit button stays enabled after all memes have been deleted
// TODO: change text on background view to say "No memes are available to display!"
// TODO: extension for background view (so shared between table and collection view controllers)

class CollectionViewController: UICollectionViewController {

	// MARK: - Properties
	
	let collectionCellReuseIdentifier = "reusableCollectionCell"
	
	
	// MARK: - Collection View Controller Overrides
	
    override func viewDidLoad() {
        super.viewDidLoad()

		navigationItem.leftBarButtonItem = editButtonItem()
   }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationItem.leftBarButtonItem?.enabled = (AppDelegate.memes.count > 0)
		
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
		
		setUpCollectionViewBackground(numItems)
		
		return numItems
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellReuseIdentifier, forIndexPath: indexPath)
		
		let cellImageView = cell.viewWithTag(1) as! UIImageView
		
		cellImageView.image = AppDelegate.memes[indexPath.row].memedImage
		
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
	
	
	// MARK: - Utility Functions
	
	func setUpCollectionViewBackground(numRows: Int) {
		
		// code modified from:
		// iOS Programming 101: Implementing Pull-to-Refresh and Handling Empty Table
		//	Simon Ng, 11 July 2014
		//	http://www.appcoda.com/pull-to-refresh-uitableview-empty/
		guard let memesCollectionView = collectionView else {
			return
		}
		
		let emptyMessageText = "No memes sent yet!\nPress + to create a new meme\nand share it."
		let fontName = "Palatino-Italic"
		let fontSize: CGFloat = 20.0
		
		if numRows > 0 {
			if memesCollectionView.backgroundView != nil {
				memesCollectionView.backgroundView = nil
			}
		}
		else {
			if memesCollectionView.backgroundView == nil {
				let emptyMessageLabel = UILabel(frame: CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
				emptyMessageLabel.text = emptyMessageText
				emptyMessageLabel.numberOfLines = 0
				emptyMessageLabel.font = UIFont(name: fontName, size: fontSize)
				emptyMessageLabel.textAlignment = .Center
				emptyMessageLabel.sizeToFit()
				
				memesCollectionView.backgroundView = emptyMessageLabel
			}
		}
	}
	


}
