//
//  TableViewController.swift
//  MemeMe
//
//  Created by leanne on 3/3/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

	// MARK: - Properties/Instance Variables
	
	var savedMemes: [Meme]!
	

	// MARK: - Overrides
	
	override func viewWillAppear(animated: Bool) {
		
		savedMemes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes

		// reload table to ensure all memes are displayed
		tableView.reloadData()
	}
	

	
	// MARK: - Table view data source

	// using default number of sections (1), so no override for numberOfSections

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let numRows = savedMemes.count
		
		// code modified from:
		// iOS Programming 101: Implementing Pull-to-Refresh and Handling Empty Table
		//	Simon Ng, 11 July 2014
		//	http://www.appcoda.com/pull-to-refresh-uitableview-empty/
		if numRows > 0 {
			if tableView.backgroundView != nil {
				tableView.backgroundView = nil
				tableView.separatorStyle = .SingleLine
			}
		}
		else {
			if tableView.backgroundView == nil {
				let emptyMessageLabel = UILabel(frame: CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
				emptyMessageLabel.text = "No memes sent yet!\nPress + to create a new meme\nand share it."
				emptyMessageLabel.numberOfLines = 0
				emptyMessageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
				emptyMessageLabel.textAlignment = .Center
				emptyMessageLabel.sizeToFit()
				
				tableView.backgroundView = emptyMessageLabel
				tableView.separatorStyle = .None
			}
		}
		
		return numRows
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
        let cell = tableView.dequeueReusableCellWithIdentifier("reusableTableCell", forIndexPath: indexPath)
		
		let currentMeme = savedMemes[indexPath.row]
		
		let cellImageView = cell.viewWithTag(1) as! UIImageView
		cellImageView.image = currentMeme.memedImage
		
		// set up text for label
		// BABY HEDGEHOG SAYS - I NEED MY SPACE
		// BABY HED...MY SPACE
		
		// COW BE LIKE - HANG TEN, BRAH
		// COW BE LI...TEN, BRAH
		
		// TEST MEME - YOU'RE DOING IT WRONG
		// TEST MEM...IT WRONG
		
		// SET UP - HILARIOUS PUNCHLINE
		// SET UP...HI...UNCHLINE
		
		let topText = currentMeme.topMemeText
		let bottomText = currentMeme.bottomMemeText
		let ellipsis = "..."
		
		// get applicable character counts
		let numTopChars = topText.characters.count
		let numBottomChars = bottomText.characters.count
		let numEllipsisChars = ellipsis.characters.count
		
		let totalNumChars = numTopChars + numBottomChars
		let totalWithEllipsis = totalNumChars + numEllipsisChars
		
		let halfPoint = totalNumChars / 2
		
		// now, setup appropriate text for label
		var labelText = ""
		if numTopChars <= halfPoint {
			labelText += topText
		}
		else {
			// calculate num chars to show before ellipsis
			labelText += "x"
		}
		
		labelText += ellipsis
		
		if numBottomChars <= halfPoint {
			labelText += bottomText
		}
		else {
			// calculate num chars to show after ellipsis
			labelText += "x"
		}
		
		
		let cellLabel = cell.viewWithTag(2) as! UILabel
		cellLabel.text = labelText

        return cell
    }
	
}
