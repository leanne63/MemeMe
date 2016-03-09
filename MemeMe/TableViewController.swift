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
		// iOS Programming 101: Implementing Pull-to-Refresh and Handling Empty Table,
		//	Simon Ng, 11 July 2014
		//	http://www.appcoda.com/pull-to-refresh-uitableview-empty/
		if numRows > 0 {
			return numRows
		}
		else {
			let emptyMessageLabel = UILabel(frame: CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
			emptyMessageLabel.text = "No memes sent yet!\nPress + to create a new meme\nand share it."
			emptyMessageLabel.numberOfLines = 0
			emptyMessageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
			emptyMessageLabel.textAlignment = .Center
			emptyMessageLabel.sizeToFit()
			
			tableView.backgroundView = emptyMessageLabel
			tableView.separatorStyle = .None
			
			return 0
		}
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
        let cell = tableView.dequeueReusableCellWithIdentifier("reusableTableCell", forIndexPath: indexPath)
		
		let currentMeme = savedMemes[indexPath.row]
		
		let imageView = cell.viewWithTag(1) as! UIImageView
		let label = cell.viewWithTag(2) as! UILabel
		
		imageView.image = currentMeme.memedImage
		
		label.text = currentMeme.topMemeText + "..." + currentMeme.bottomMemeText

        return cell
    }
	
}
