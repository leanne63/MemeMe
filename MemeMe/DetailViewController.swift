//
//  DetailViewController.swift
//  MemeMe
//
//  Created by leanne on 3/11/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	
	// MARK: - Properties (Non-Outlets)
	
	var selectedMeme: Meme!
	
	
	// MARK: - Properties (Outlets)
	
	@IBOutlet weak var imageView: UIImageView!
	
	
	// MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
		
		imageView.image = selectedMeme.memedImage
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		guard let segueId = segue.identifier else {
			return
		}
		
		switch segueId {
			
		case "detailViewSegueToEditor":
			let controller = segue.destinationViewController as! EditorViewController
			controller.topTextField.text = selectedMeme.topMemeText
			controller.bottomTextField.text = selectedMeme.bottomMemeText
			controller.memeImageView.image = selectedMeme.originalImage
			controller.memedImage = selectedMeme.memedImage
			
		default:
			print("invalid segue")
		}
    }
	
}
