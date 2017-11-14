//
//  TableViewController.swift
//  MemeMe
//
//  Created by leanne on 3/3/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
	
	// MARK: - Properties
	
	let tableCellReuseIdentifier = "reusableTableCell"
	
	// indicates whether this controller initiated a segue
	//  used to determine whether this controller can respond to an unwind request
	var startedEditorSegue = false
	var startedDetailSegue = false
	
	
	// MARK: - Table View Controller Overrides
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = editButtonItem
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let numMemes = MemeData.allMemes.count
		let isEmpty = (numMemes == 0)
		
		navigationItem.leftBarButtonItem?.isEnabled = !isEmpty
		
		setUpTableViewBackground(isEmpty)

		// reload table to ensure all memes are displayed
		tableView.reloadData()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		guard let segueId = segue.identifier else {
			return
		}
		
		switch segueId {
			
		case "tableViewSegueToDetail":
			let sendingCell = sender as! UITableViewCell
			let sendingCellIndexPath = tableView.indexPath(for: sendingCell)!
			let selectedMeme = sendingCellIndexPath.row
			
			let controller = segue.destination as! DetailViewController
			controller.selectedMeme = MemeData.allMemes[selectedMeme]
			
			startedDetailSegue = true
			
		case "tableViewSegueToEditor":
			startedEditorSegue = true
		
		default:
			print("unknown segue: \(segueId)")
		}
	}
	
	override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
		
		// if we started the segue, then we can handle it; otherwise, pass
		switch action {
			
		case #selector(TableViewController.unwindFromEditor(_:)):
			let isUnwindResponder = startedDetailSegue || startedEditorSegue
			
			return isUnwindResponder
			
		default:
			return false
		}
	}
	
	
	// MARK: - Actions
	
	@IBAction func unwindFromEditor(_ segue: UIStoryboardSegue) {
		
		// the editor's unwind came here; all we need do is revert the indicator
		//	to false, so it's valid for the next unwind action
		startedEditorSegue = false
		startedDetailSegue = false
	}
	
	
	// MARK: - Table View Data Source

	// using default number of sections (1), so no override for numberOfSections

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let numRows = MemeData.allMemes.count
		
		return numRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath)
		
		let currentMeme = MemeData.allMemes[indexPath.row]
		
		let cellImageView = cell.viewWithTag(1) as! UIImageView
		cellImageView.image = currentMeme.memedImage
		
		let topText = currentMeme.topMemeText
		let bottomText = currentMeme.bottomMemeText
		let labelText: String = generateLabelText(topText!, bottomText: bottomText!)
		
		let cellLabel = cell.viewWithTag(2) as! UILabel
		cellLabel.text = labelText

        return cell
    }
	
	
	// MARK: - Table View Delegate
	
	// required to allow row deletion
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		
		return true
	}
	
	// do the deletion
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete {
			MemeData.allMemes.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
			
			// Done button doesn't change back automatically (as of Xcode 7, iOS 9),
			//	so let's save the user some effort and change it back for them
			if MemeData.allMemes.count == 0 {
				let editButton = navigationItem.leftBarButtonItem!
				editButton.title = "Edit"
				editButton.isEnabled = false
				
				let isEmpty = true
				setUpTableViewBackground(isEmpty)
			}
		}
	}
	
	
	// MARK: - Utility Functions
	
	func setUpTableViewBackground(_ isEmpty: Bool) {
		
		// code modified from:
		// iOS Programming 101: Implementing Pull-to-Refresh and Handling Empty Table
		//	Simon Ng, 11 July 2014
		//	http://www.appcoda.com/pull-to-refresh-uitableview-empty/
		
		let emptyMessageText = "No memes sent yet!\nPress + to create a new meme\nand share it."
		let fontName = "Palatino-Italic"
		let fontSize: CGFloat = 20.0
		
		if !isEmpty {
			if tableView.backgroundView != nil {
				tableView.backgroundView = nil
				tableView.separatorStyle = .singleLine
			}
		}
		else {
			if tableView.backgroundView == nil {
				let emptyMessageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
				emptyMessageLabel.text = emptyMessageText
				emptyMessageLabel.numberOfLines = 0
				emptyMessageLabel.font = UIFont(name: fontName, size: fontSize)
				emptyMessageLabel.textAlignment = .center
				emptyMessageLabel.sizeToFit()
				
				tableView.backgroundView = emptyMessageLabel
				tableView.separatorStyle = .none
			}
		}
	}
	
	func generateLabelText(_ topText: String, bottomText: String) -> String {
		
		let ellipsis = "..."
		
		let maxNumCharsAvail = 22
		let halfNumCharsAvail = maxNumCharsAvail / 2
		
		let topTextLen = topText.characters.count
		let bottomTextLen = bottomText.characters.count
		
		var remainingCharsAvail = maxNumCharsAvail
		var labelText = ""
		
		// set up first half label...
		if topTextLen <= halfNumCharsAvail {
			labelText += topText
		}
		else {
			// truncate top text to halfway point
			let index = topText.characters.index(topText.startIndex, offsetBy: halfNumCharsAvail)
			labelText += topText.substring(to: index)
		}
		
		remainingCharsAvail -= labelText.characters.count
		
		labelText += ellipsis
		
		// set up second half label
		if bottomTextLen <= remainingCharsAvail {
			labelText += bottomText
		}
		else {
			// truncate bottom text to fit
			if remainingCharsAvail <= halfNumCharsAvail {
				// no room left over from the front, so simply truncate
				let index = bottomText.characters.index(bottomText.endIndex, offsetBy: -(remainingCharsAvail))
				labelText += bottomText.substring(from: index)
			}
			else {
				// room was left at the front, so split the truncation between front and back
				// get remainder at front; fill it with beginning of bottom text
				let numCharsLeftAtFront = remainingCharsAvail - halfNumCharsAvail
				let frontIndex = bottomText.characters.index(bottomText.startIndex, offsetBy: numCharsLeftAtFront)
				labelText += bottomText.substring(to: frontIndex)
				
				// add ellipsis
				labelText += ellipsis
				remainingCharsAvail = halfNumCharsAvail - ellipsis.characters.count
				
				// get remainder at end; fill with ending of bottom text
				let backIndex = bottomText.characters.index(bottomText.endIndex, offsetBy: -(remainingCharsAvail))
				labelText += bottomText.substring(from: backIndex)
			}
		}
		
		return labelText
	}
}
