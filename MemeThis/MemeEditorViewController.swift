//
//  ViewController.swift
//  MemeThis
//
//  Created by Jeff Boschee on 2/5/16.
//  Copyright © 2016 Mindcloud. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var myMemeImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbarBottom: UIToolbar!
    @IBOutlet weak var buttonShare: UIBarButtonItem!
    @IBOutlet weak var buttonCancel: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    // Get Status Bar Out of the way
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(topTextField)
        setupTextField(bottomTextField)
        initializeFields()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.subscribeToKeyboardNotications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    func setupTextField(textField: UITextField) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Impact", size: 50)!,
            NSStrokeWidthAttributeName: -3.0
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
        textField.delegate = self
    }
    
    func initializeFields() {
        myMemeImage.image = nil
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        buttonShare.enabled = false
        buttonCancel.enabled = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getImage(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.editing = false
        pickerController.sourceType = sourceType
        self.presentViewController(pickerController, animated: true, completion: nil)
    }

    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        getImage(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        getImage(UIImagePickerControllerSourceType.Camera)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let tempImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            myMemeImage.image = tempImage
            buttonShare.enabled = true
            buttonCancel.enabled = true
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Shift View when Keyboard is visible
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() && view.frame.origin.y == 0 {
            self.view.frame.origin.y -= getKeyBoardHeight(notification)
        }
    }
    
    // Get Keyboard height from userInfo
    func getKeyBoardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    // Reset the app
    @IBAction func cancelTapped(sender: AnyObject) {
        /*
        let refreshAlert = UIAlertController(title: "Cancel Meme?", message: "This will reset the meme editor, sure?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popToRootViewControllerAnimated(true)
            self.initializeFields()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
*/
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            // Return if cancelled
            if (!completed) {
                return
            }
            
            // Save the Meme
            let newMeme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, original: self.myMemeImage.image!, memedImage: memedImage)
            newMeme.save()
        }
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func toggleToolBars(visible: Bool) {
        if visible {
            // Show Bars
            toolbarBottom.hidden = false
            navBar.hidden = false
            myMemeImage.frame = CGRectMake(20 ,navBar.frame.height, view.frame.width - 40, view.frame.height - (toolbarBottom.frame.height * 2))
            topTextField.placeholder = "TOP"
            bottomTextField.placeholder = "BOTTOM"
        }
        else {
            navBar.hidden = true
            toolbarBottom.hidden = true
            myMemeImage.frame = CGRectMake(0 , 0, view.frame.width, view.frame.height)
            topTextField.placeholder = ""
            bottomTextField.placeholder = ""
        }
    }
    
    func generateMemedImage() -> UIImage {
        toggleToolBars(false)
        myMemeImage.updateConstraints()
        UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, 0.0)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        toggleToolBars(true)
        return memedImage
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y += getKeyBoardHeight(notification)
        }
    }
    
    func subscribeToKeyboardNotications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
}

