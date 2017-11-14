//
//  EditorViewController.swift
//  MemeMe_v2.0
//
//  Created by leanne on 2/21/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

	// MARK: - Properties (Outlets)
	
	@IBOutlet weak var navBar: UINavigationBar!
	@IBOutlet weak var toolBar: UIToolbar!
	
	@IBOutlet weak var memeImageView: UIImageView!
	
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	
	@IBOutlet weak var albumButton: UIBarButtonItem!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	
	@IBOutlet weak var activityButton: UIBarButtonItem!
	
	// MARK: - Properties (Non-Outlets)
	
	var cameFromDetail = false
	
	var defaultTopText = "TOP"
	var defaultBottomText = "BOTTOM"
	
	var selectedImage: UIImage!
	var memedImage: UIImage!
	
	
	// MARK: - View Controller Overrides
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		topTextField.delegate = self
		bottomTextField.delegate = self
		
		setCommonFontStyling(topTextField)
		setCommonFontStyling(bottomTextField)
		
		topTextField.text = defaultTopText
		bottomTextField.text = defaultBottomText
		if let anImage = selectedImage {
			memeImageView.image = anImage
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		albumButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
		
		activityButton.isEnabled = (memeImageView.image != nil) ? true : false
		
		subscribeToKeyboardNotifications()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		unsubscribeFromKeyboardNotifications()
	}
	
	
	// MARK: - Actions
	
	@IBAction func cancelEditing(_ sender: UIBarButtonItem) {
		
		if cameFromDetail == true {
			// return to detail view instead of table/collection
			dismiss(animated: true, completion: nil)
		}
		else {
			// return to table/collection
			performSegue(withIdentifier: "unwindSegueFromEditor", sender: self)
		}
	}
	
	@IBAction func pickAMemeImage(_ sender: UIBarButtonItem) {
		
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		
		// define controller's source type based on method for image selection
		// (implicitly unwrapping since we'll return if no valid source type)
		var sourceType: UIImagePickerControllerSourceType!
		
		switch sender {
			
		case albumButton:
			sourceType = .photoLibrary
			
		case cameraButton:
			sourceType = .camera
			
		default:
			print("unknown sender: \(sender)")
			return
		}
		
		imagePickerController.sourceType = sourceType
		
		present(imagePickerController, animated: true, completion: nil)
	}
	
	@IBAction func shareMeme(_ sender: UIBarButtonItem) {
		
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
			(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?) -> Void in
		
			if completed {
				self.saveMeme()
				
				self.performSegue(withIdentifier: "unwindSegueFromEditor", sender: self)
			}
		}
		
		present(activityViewController, animated: true, completion: nil)
	}
	
	
	// MARK: - Image Picker Delegate Methods
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		
		memeImageView.image = (info[UIImagePickerControllerOriginalImage] as! UIImage)
		
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		
		dismiss(animated: true, completion: nil)
	}

	
	// MARK: - Text Field Delegate Methods
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		dismissKeyboard(textField)
		
		return true
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

		let currentText = textField.text! as NSString
		let capitalizedText = currentText.replacingCharacters(in: range, with: string.uppercased())
		
		textField.text = capitalizedText
		
		return false
	}
	
	
	// MARK: - Subscribe/Unsubscribe to Notifications
	
	func subscribeToKeyboardNotifications() {
		
		// watch for the keyboard to show
		NotificationCenter.default.addObserver(self,
			selector: #selector(EditorViewController.keyboardWillShow(_:)),
			name: NSNotification.Name.UIKeyboardWillShow,
			object: nil)
		
		// watch for the keyboard to hide
		NotificationCenter.default.addObserver(self,
			selector: #selector(EditorViewController.keyboardWillHide(_:)),
			name: NSNotification.Name.UIKeyboardWillHide,
			object: nil)
	}
	
	func unsubscribeFromKeyboardNotifications() {
		
		// no longer need to watch for keyboard to show
		NotificationCenter.default.removeObserver(self,
			name: NSNotification.Name.UIKeyboardWillShow,
			object: nil)

		// no longer need to watch for keyboard to hide
		NotificationCenter.default.removeObserver(self,
			name: NSNotification.Name.UIKeyboardWillHide,
			object: nil)
	}
	
	
	// MARK: - Respond to Notifications
	
	@objc func keyboardWillShow(_ notification: Notification) {
		
		// if we're entering bottom text, move the image up so we can see our edits
		if bottomTextField.isFirstResponder {
			view.frame.origin.y -= getKeyboardHeight(notification)
		}
	}
	
	@objc func keyboardWillHide(_ notification: Notification) {
		
		// if we were entering bottom text, move the image back down to normal
		if bottomTextField.isFirstResponder {
			view.frame.origin.y = 0
		}
	}
	
	
	// MARK: - Utility Functions
	
	func setCommonFontStyling(_ textField: UITextField) {
		
		let paragraphStyleToCenterText = NSMutableParagraphStyle()
		paragraphStyleToCenterText.alignment = NSTextAlignment.center
		
		let memeTextAttributes: [String: Any] = [
			NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
			NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
			NSAttributedStringKey.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
			NSAttributedStringKey.strokeWidth.rawValue : -3.0,
			
			NSAttributedStringKey.paragraphStyle.rawValue : paragraphStyleToCenterText,
		]
		
		textField.defaultTextAttributes = memeTextAttributes
		textField.adjustsFontSizeToFitWidth = true
	}
	
	func dismissKeyboard(_ textField: UITextField) {
		
		// dismiss the keyboard
		textField.endEditing(true)
		textField.resignFirstResponder()
	}
	
	func getKeyboardHeight(_ notification: Notification) -> CGFloat {
		
		let userInfo = notification.userInfo!
		
		let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
		let keyboardSizeAsFloat = keyboardSize.cgRectValue.height
		
		return keyboardSizeAsFloat
	}
	
	func generateMemedImage() -> UIImage {
		// hide the tool and nav bars, so won't show in image
		navBar.isHidden = true
		toolBar.isHidden = true
		
		// Render view to an image, using a context
		UIGraphicsBeginImageContext(self.view.frame.size)
		
		view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
		let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		
		UIGraphicsEndImageContext()
		
		// return the tool and nav bars back to normal
		navBar.isHidden = false
		toolBar.isHidden = false
		
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
		MemeData.allMemes.append(meme)
	}
	
}

