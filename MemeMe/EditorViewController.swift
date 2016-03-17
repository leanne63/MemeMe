//
//  EditorViewController.swift
//  MemeMe_v2.0
//
//  Created by leanne on 2/21/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

	// MARK: - Outlets
	
	@IBOutlet weak var memeImageView: UIImageView!
	
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	
	//@IBOutlet weak var toolBar: UIToolbar!
	@IBOutlet weak var albumButton: UIBarButtonItem!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	
	@IBOutlet weak var activityButton: UIBarButtonItem!
	
	// MARK: - Properties
	
	// setting text constants for use as needed
	let defaultTopText = "TOP"
	let defaultBottomText = "BOTTOM"
	
	var memedImage: UIImage!
	
	
	// MARK: - View Controller Overrides
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		topTextField.delegate = self
		bottomTextField.delegate = self
		
		setCommonFontStyling(topTextField)
		setCommonFontStyling(bottomTextField)
	}
	
	override func viewWillAppear(animated: Bool) {
		
		super.viewWillAppear(animated)
		
		albumButton.enabled = UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
		cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
		
		activityButton.enabled = (memeImageView.image != nil) ? true : false
		
		subscribeToKeyboardNotifications()
	}
	
	override func viewWillDisappear(animated: Bool) {
		
		super.viewWillDisappear(animated)
		
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
	
	@IBAction func shareMeme(sender: UIBarButtonItem) {
		
		memedImage = generateMemedImage()
		
		let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
		
		/*
		 * fixes crash on iPads, error message:
		 * Terminating app due to uncaught exception 'NSGenericException', reason: 'UIPopoverPresentationController (<_UIAlertControllerActionSheetRegularPresentationController: 0x7fc7a874bd90>) should have a non-nil sourceView or barButtonItem set before the presentation occurs.'
		 *
		 * from: http://stackoverflow.com/questions/25644054/uiactivityviewcontroller-crashing-on-ios8-ipads?answertab=oldest#tab-top
		 *
		 * answer by: Martín Marconcini
		 *
		 */
		activityViewController.popoverPresentationController?.barButtonItem = sender
		
		activityViewController.completionWithItemsHandler = {
			(activityType: String?, completed: Bool, returnedItems: [AnyObject]?, activityError: NSError?) -> Void in
		
			if completed {
				self.saveMeme()
				
				self.dismissViewControllerAnimated(true, completion: nil)
			}
		}
		
		presentViewController(activityViewController, animated: true, completion: nil)
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
		
		dismissKeyboard(textField)
		
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
		if bottomTextField.isFirstResponder() {
			view.frame.origin.y -= getKeyboardHeight(notification)
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		
		// if we were entering bottom text, move the image back down to normal
		if bottomTextField.isFirstResponder() {
			view.frame.origin.y = 0
		}
	}
	
	
	// MARK: - Utility Functions
	
	func setCommonFontStyling(textField: UITextField) {
		
		let paragraphStyleToCenterText = NSMutableParagraphStyle()
		paragraphStyleToCenterText.alignment = NSTextAlignment.Center
		
		let memeTextAttributes = [
			NSStrokeColorAttributeName : UIColor.blackColor(),
			NSForegroundColorAttributeName : UIColor.whiteColor(),
			NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
			NSStrokeWidthAttributeName : -3.0,
			
			NSParagraphStyleAttributeName : paragraphStyleToCenterText,
		]
		
		textField.defaultTextAttributes = memeTextAttributes
		textField.adjustsFontSizeToFitWidth = true
	}
	
	func dismissKeyboard(textField: UITextField) {
		
		// dismiss the keyboard
		textField.endEditing(true)
		textField.resignFirstResponder()
	}
	
	func getKeyboardHeight(notification: NSNotification) -> CGFloat {
		
		let userInfo = notification.userInfo!
		
		let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
		let keyboardSizeAsFloat = keyboardSize.CGRectValue().height
		
		return keyboardSizeAsFloat
	}
	
	func generateMemedImage() -> UIImage {
		// hide the tool and nav bars, so won't show in image
		self.navigationController?.toolbarHidden = true
		//toolBar.hidden = true
		navigationController?.navigationBar.hidden = true
		
		// Render view to an image, using a context
		UIGraphicsBeginImageContext(self.view.frame.size)
		
		view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
		let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
		
		UIGraphicsEndImageContext()
		
		// return the tool and nav bars back to normal
		self.navigationController?.toolbarHidden = false
		//toolBar.hidden = false
		navigationController?.navigationBar.hidden = false
		
		return memedImage
	}
	
	func saveMeme() {
		
		// instantiate a meme object
		let meme = Meme.init(
			topMemeText: topTextField.text,
			bottomMemeText: bottomTextField.text,
			originalImage: memeImageView.image,
			memedImage: memedImage)
		
		// add it to our app's array of memes
		AppDelegate.memes.append(meme)
	}
	
}

