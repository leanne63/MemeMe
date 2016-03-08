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
	var count = 0
	

	// MARK: - Overrides
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	override func viewWillAppear(animated: Bool) {
		
		savedMemes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes

		tableView.reloadData()
	}

	
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
		
		imageView.contentMode = .ScaleAspectFill
		imageView.image = currentMeme.memedImage
		
		label.text = currentMeme.topMemeText + "..." + currentMeme.bottomMemeText

		print("\(++count) times through...")
		print("imageView width: \(imageView.frame.width)")
		print("label width: \(label.frame.width)")
		print("text length: \(label.text?.characters.count)")
		print("\n")
		
        return cell
    }
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
