//
//  MemeMeViewController.swift
//  MemeMe_v1.0
//
//  Created by leanne on 2/21/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

	// MARK: - Outlets
	
	@IBOutlet weak var memeImageView: UIImageView!
	@IBOutlet weak var albumButton: UIBarButtonItem!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var topLabel: UITextField!
	@IBOutlet weak var bottomLabel: UITextField!
	
	
	// MARK: - Properties
	
	// setting text constants for use as needed
	let defaultTopText = "TOP"
	let defaultBottomText = "BOTTOM"
	
	
	// MARK: - View Controller Overrides
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		topLabel.delegate = self
		bottomLabel.delegate = self
		
		// set up font styling
		let paragraphStyleToCenterText = NSMutableParagraphStyle()
		paragraphStyleToCenterText.alignment = NSTextAlignment.Center
		
		let memeTextAttributes = [
			NSStrokeColorAttributeName : UIColor.blackColor(),
			NSForegroundColorAttributeName : UIColor.whiteColor(),
			NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
			NSStrokeWidthAttributeName : -3.0,
			
			NSParagraphStyleAttributeName : paragraphStyleToCenterText,
		]
		
		topLabel.defaultTextAttributes = memeTextAttributes
		bottomLabel.defaultTextAttributes = memeTextAttributes
		
		subscribeToKeyboardNotifications()
	}
	
	override func viewWillAppear(animated: Bool) {
		
		super.viewWillAppear(animated)
		
		albumButton.enabled = UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
		cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
	}
	
	override func viewWillDisappear(animated: Bool) {
		
		super.viewWillDisappear(animated)
		
		// unsubscribe from notifications before view goes away
		unsubscribeFromKeyboardNotifications()
	}
	
	
	// MARK: - Actions
	
	@IBAction func pickAMemeImage(sender: UIBarButtonItem) {
		
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		
		// define controller's source type based on method for image selection
		// (implicitly unwrapping since we'll return if no valid source type)
		var sourceType: UIImagePickerControllerSourceType!
		
		switch sender {
			
		case albumButton:
			sourceType = .PhotoLibrary
			
		case cameraButton:
			sourceType = .Camera
			
		default:
			print("invalid sender")
			return
		}
		
		imagePickerController.sourceType = sourceType
		
		presentViewController(imagePickerController, animated: true, completion: nil)
	}
	
	@IBAction func cancelMemeEditor(sender: UIBarButtonItem) {
		
		// return to default state
		topLabel.attributedText = NSAttributedString(string: defaultTopText)
		bottomLabel.attributedText = NSAttributedString(string: defaultBottomText)
		
		memeImageView.image = nil
	}
	
	
	// MARK: - Image Picker Delegate Methods
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		
		memeImageView.image = image
		
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		
		dismissViewControllerAnimated(true, completion: nil)
	}

	
	// MARK: - Text Field Delegate Methods
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		
		// dismiss the keyboard
		textField.endEditing(true)
		textField.resignFirstResponder()
		
		return true
	}
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

		let currentText = textField.text! as NSString
		let capitalizedText = currentText.stringByReplacingCharactersInRange(range, withString: string.uppercaseString)
		
		textField.text = capitalizedText
		
		return false
	}
	
	
	// MARK: - Subscribe/Unsubscribe to Notifications
	
	func subscribeToKeyboardNotifications() {
		
		// watch for the keyboard to show
		NSNotificationCenter.defaultCenter().addObserver(self,
			selector: "keyboardWillShow:",
			name: UIKeyboardWillShowNotification,
			object: nil)
		
		// watch for the keyboard to hide
		NSNotificationCenter.defaultCenter().addObserver(self,
			selector: "keyboardWillHide:",
			name: UIKeyboardWillHideNotification,
			object: nil)
	}
	
	func unsubscribeFromKeyboardNotifications() {
		
		// no longer need to watch for keyboard to show
		NSNotificationCenter.defaultCenter().removeObserver(self,
			name: UIKeyboardWillShowNotification,
			object: nil)

		// no longer need to watch for keyboard to hide
		NSNotificationCenter.defaultCenter().removeObserver(self,
			name: UIKeyboardWillHideNotification,
			object: nil)
}
	
	
	// MARK: - Respond to Notifications
	
	func keyboardWillShow(notification: NSNotification) {
		
		// if we're entering bottom text, move the image up so we can see our edits
		if bottomLabel.isFirstResponder() {
			view.frame.origin.y -= getKeyboardHeight(notification)
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		
		// if we're entering bottom text, move the image up so we can see our edits
		if bottomLabel.isFirstResponder() {
			view.frame.origin.y += getKeyboardHeight(notification)
		}
	}
	
	
	// MARK: - Utility Functions
	
	func getKeyboardHeight(notification: NSNotification) -> CGFloat {
		
		let userInfo = notification.userInfo!
		
		let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
		let keyboardSizeAsFloat = keyboardSize.CGRectValue().height
		
		return keyboardSizeAsFloat
	}
	
}

