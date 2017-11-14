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
	
	let reusableCollectionCellIdentifier = "reusableCollectionCell"
	
	// indicates whether this controller initiated a segue - 
	//  used to determine whether this controller can respond to an unwind request
	var startedEditorSegue = false
	var startedDetailSegue = false
	
	
	// MARK: - Collection View Controller Overrides
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Register cell classes - not needed because "registered" within storyboard
		// self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reusableCollectionCellIdentifier)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let numMemes = MemeData.allMemes.count
		let isEmpty = (numMemes == 0)
		
		setUpCollectionViewBackground(isEmpty)
		
		// reload collection to ensure all memes are displayed
		collectionView!.reloadData()
	}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		guard let segueId = segue.identifier else {
			return
		}
		
		switch segueId {
			
		case "collectionViewSegueToDetail":
			let sendingCell = sender as! UICollectionViewCell
			let sendingCellIndexPath = collectionView!.indexPath(for: sendingCell)!
			let selectedMeme = sendingCellIndexPath.row
			
			let controller = segue.destination as! DetailViewController
			controller.selectedMeme = MemeData.allMemes[selectedMeme]
			
			startedDetailSegue = true
			
		case "collectionViewSegueToEditor":
			startedEditorSegue = true
			
		default:
			print("unknown segue: \(segueId)")
		}
    }
	
	override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
		
		// if we started the segue, then we can handle it; otherwise, pass
		switch action {
			
		case #selector(CollectionViewController.unwindFromEditor(_:)):
			let isUnwindResponder = startedDetailSegue || startedEditorSegue
			
			return isUnwindResponder
			
		default:
			return false
		}
	}
	
	override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
		
		// redraw on rotation so resizes cells properly
		collectionView!.reloadData()
	}
	
	
	// MARK: - Actions
	
	@IBAction func unwindFromEditor(_ segue: UIStoryboardSegue) {
		
		// the editor's unwind came here; all we need do is revert the indicator
		//	to false, so it's valid for the next unwind action
		startedEditorSegue = false
		startedDetailSegue = false
	}
	
	
	// MARK: - Collection View Data Source

	// using default number of sections (1), so no override for numberOfSections
	
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		let numItems = MemeData.allMemes.count
		
		return numItems
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCollectionCellIdentifier, for: indexPath)
		
		let cellImageView = cell.viewWithTag(1) as! UIImageView
		
		cellImageView.image = MemeData.allMemes[indexPath.row].memedImage
		
        return cell
    }

	
	// MARK: - Utility Functions
	
	func setUpCollectionViewBackground(_ isEmpty: Bool) {
		
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
				let emptyMessageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
				emptyMessageLabel.text = emptyMessageText
				emptyMessageLabel.numberOfLines = 0
				emptyMessageLabel.font = UIFont(name: fontName, size: fontSize)
				emptyMessageLabel.textAlignment = .center
				emptyMessageLabel.sizeToFit()
				
				theCollectionView.backgroundView = emptyMessageLabel
			}
		}
	}
	
}
