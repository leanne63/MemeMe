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
		
		// set up text to go with meme image
		let ellipsis = "..."
		
		let maxNumCharsAvail = 22
		let halfNumCharsAvail = maxNumCharsAvail / 2
		
		var remainingCharsAvail = maxNumCharsAvail
		var labelText = ""

		let topText = currentMeme.topMemeText
		let topTextLen = topText.characters.count
		
		if topTextLen <= halfNumCharsAvail {
			labelText += topText
		}
		else {
			// truncate top text to halfway point
			let index = topText.startIndex.advancedBy(halfNumCharsAvail)
			labelText += topText.substringToIndex(index)
		}
		
		remainingCharsAvail -= labelText.characters.count
		
		labelText += ellipsis
		
		let bottomText = currentMeme.bottomMemeText
		let bottomTextLen = bottomText.characters.count
		
		if bottomTextLen <= remainingCharsAvail {
			labelText += bottomText
		}
		else {
			// truncate bottom text to fit
			if remainingCharsAvail <= halfNumCharsAvail {
				// no room left over from the front, so simply truncate
				let index = bottomText.endIndex.advancedBy(-(remainingCharsAvail))
				labelText += bottomText.substringFromIndex(index)
			}
			else {
				// room was left at the front, so split the truncation between front and back
				// get remainder at front; fill it with beginning of bottom text
				let numCharsLeftAtFront = remainingCharsAvail - halfNumCharsAvail
				let frontIndex = bottomText.startIndex.advancedBy(numCharsLeftAtFront)
				labelText += bottomText.substringToIndex(frontIndex)
				
				// add ellipsis
				labelText += ellipsis
				remainingCharsAvail = halfNumCharsAvail - ellipsis.characters.count
				
				// get remainder at end; fill with ending of bottom text
				let backIndex = bottomText.endIndex.advancedBy(-(remainingCharsAvail))
				labelText += bottomText.substringFromIndex(backIndex)
			}
		}
		
		let cellLabel = cell.viewWithTag(2) as! UILabel
		cellLabel.text = labelText

        return cell
    }
	
}
