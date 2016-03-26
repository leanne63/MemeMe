//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by leanne on 3/11/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	// MARK: - Properties: Non-Outlets
	
	let collectionCellReuseIdentifier = "reusableCollectionCell"
	
	// indicates whether this controller initiated a segue
	//  used to determine whether this controller can respond to an unwind request
	var startedEditorSegue = false
	var startedDetailSegue = false
	
	
	// MARK: - Collection View Controller Overrides
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let numMemes = Meme.allMemes.count
		let isEmpty = (numMemes == 0)
		
		setUpCollectionViewBackground(isEmpty)
		
		// reload collection to ensure all memes are displayed
		collectionView!.reloadData()
	}

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		guard let segueId = segue.identifier else {
			return
		}
		
		switch segueId {
			
		case "collectionViewSegueToDetail":
			let sendingCell = sender as! UICollectionViewCell
			let sendingCellIndexPath = collectionView!.indexPathForCell(sendingCell)!
			let selectedMeme = sendingCellIndexPath.row
			
			let controller = segue.destinationViewController as! DetailViewController
			controller.selectedMeme = Meme.allMemes[selectedMeme]
			
			startedDetailSegue = true
			
		case "collectionViewSegueToEditor":
			startedEditorSegue = true
			
		default:
			print("unknown segue: \(segueId)")
		}
    }
	
	override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
		
		// if we started the segue, then we can handle it; otherwise, pass
		switch action {
			
		case #selector(CollectionViewController.unwindFromEditor(_:)):
			let isUnwindResponder = startedDetailSegue || startedEditorSegue
			
			return isUnwindResponder
			
		default:
			return false
		}
	}
	
	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		
		// redraw on rotation so resizes cells properly
		collectionView!.reloadData()
	}
	
	
	// MARK: - Actions
	
	@IBAction func unwindFromEditor(segue: UIStoryboardSegue) {
		
		// the editor's unwind came here; all we need do is revert the indicator
		//	to false, so it's valid for the next unwind action
		startedEditorSegue = false
		startedDetailSegue = false
	}
	
	
	// MARK: - Collection View Data Source

	// using default number of sections (1), so no override for numberOfSections
	
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		let numItems = Meme.allMemes.count
		
		return numItems
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellReuseIdentifier, forIndexPath: indexPath)
		
		let cellImageView = cell.viewWithTag(1) as! UIImageView
		
		cellImageView.image = Meme.allMemes[indexPath.row].memedImage
		
        return cell
    }

	
	// MARK: - Collection View Delegate Flow Layout Methods
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		
		// retrieve width available to us
		let numItemsPerRow: CGFloat = 3.0
		let numSpacesPerRow: CGFloat = numItemsPerRow - 1.0
		
		let grossAvailWidth: CGFloat = collectionView.bounds.size.width
		
		let thisLayout = collectionViewLayout as! UICollectionViewFlowLayout
		let interimSpacing: CGFloat = thisLayout.minimumInteritemSpacing
		
		let totalInterimSpace: CGFloat = interimSpacing * numSpacesPerRow

		let netAvailWidth: CGFloat = grossAvailWidth - totalInterimSpace
		
		let itemWidth: CGFloat = netAvailWidth / numItemsPerRow
		
		// retrieve aspect ratio constraint - hardcoded for now
		let aspectRatio: CGFloat = 9.0 / 16.0
		
		// based on width and aspect ratio, set height
		let itemHeight: CGFloat = itemWidth * aspectRatio
		let itemSize = CGSizeMake(itemWidth, itemHeight)
		
		return itemSize
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
