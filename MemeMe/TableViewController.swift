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
	
//	override func viewDidLoad() {
//        super.viewDidLoad()
//		
//		subscribeToOrientationChangeNotifications()
//    }
	
	override func viewWillAppear(animated: Bool) {
		
		savedMemes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes

		// reload table to ensure all memes are displayed
		tableView.reloadData()
	}
	
//	override func viewWillDisappear(animated: Bool) {
//		
//		unsubscribeToOrientationChangeNotifications()
//	}
	
	
	// MARK: - Subscribe/Unsubscribe to Notifications

//	func subscribeToOrientationChangeNotifications() {
//		
//		NSNotificationCenter.defaultCenter().addObserver(self,
//			selector: "orientationWillChange:",
//			name: UIDeviceOrientationDidChangeNotification,
//			object: nil)
//	}
//	
//	func unsubscribeToOrientationChangeNotifications() {
//		
//		NSNotificationCenter.defaultCenter().removeObserver(self,
//			name: UIDeviceOrientationDidChangeNotification,
//			object: nil)
//	}
	
	
	// MARK: - Respond to Notifications
	
//	func orientationWillChange(notification: NSNotification) {
//		
//		// when orientation changes, need to refresh layout
//		view.layoutSubviews()
//	}

	
	// MARK: - Table view data source

	// using default number of sections (1), so no override for numberOfSections

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let numRows = savedMemes.count
		
        return numRows
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
