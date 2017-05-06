//
//  MemeMeVC.swift
//  MemeMe
//
//  Created by Marc on 4/30/17.
//  Copyright © 2017 Marc. All rights reserved.
//

import UIKit

class MemeMeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var textFieldTop: UITextField!
    @IBOutlet var textFieldBottom: UITextField!
    
    @IBOutlet var imagePickerView: UIImageView!
    var memedImage: UIImage!
    
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var cameraButton: UIBarButtonItem!
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var toolBar: UIToolbar!

    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        // Update the top textfields attributes
        configureTextFields(textFieldTop)
        
        // Update the bottom textfield attributes
        configureTextFields(textFieldBottom)
        
        // prevents sharing nothing
        shareButton.isEnabled = false
        
        // Fits the image into the view without stretching
        imagePickerView.contentMode = .scaleAspectFit
        

    }

    @IBAction func cancelMeme(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // Pick an Image from your photo album
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
        presentImagePickerWith(sourceType: .photoLibrary)
        
    }
    
    // Pick an image taken from the camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        presentImagePickerWith(sourceType: .camera)
        
    }
    

    // Share your new meme
    @IBAction func shareMeme(_ sender: Any) {
        memedImage = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = view
        
        present(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = {
            (activity, successful, nil, error) in
            if successful {
                self.save()
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func configureTextFields(_ textField: UITextField) {
        // Sets the textfield attributes
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: Float(-5.0)]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
    }
    
    // Will either open Photo Album or Camera based on parameter input
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // source will either be camera or photoLibrary
        imagePicker.sourceType = sourceType
        
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    // Allows the selected image to appear on the view controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Cancels the Image View Controller
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Simple function that removes the keyboard when touching outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // Deletes the current text in the active text field if labeled as TOP or BOTTOM
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    // Removes the keyboard when the return button is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // When a new view appears
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Disables the camera on devices with no camera
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        subscribeToKeyboardNotifications()
    }
    
    // When a view disappears
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // Function to alter the frame if the keyboard will cover the text field
    func keyboardWillShow(_ notification:Notification) {
        if textFieldBottom.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification: notification as NSNotification)
        }
    }
    
    // Returns the frame to it's original position
    func keyboardWillHide(_ notification:Notification) {
    
        view.frame.origin.y = 0
        
    }
    
    // Returns the height of the keyboard to know how much to alter the frame when it appears
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    // Create the current memed image by attaching the text to the image (i.e printScreen)
    func generateMemedImage() -> UIImage {
        
        // DONE: Hide toolbar and navbar
        configureBars(hidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // DONE: Show toolbar and navbar
        configureBars(hidden: false)
        
        return memedImage
    }
    
    // Simple function that turns the navigation/tool bars on and off
    func configureBars(hidden: Bool) {
        navBar.isHidden = hidden
        toolBar.isHidden = hidden
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: textFieldTop.text!, bottomText: textFieldBottom.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
}

