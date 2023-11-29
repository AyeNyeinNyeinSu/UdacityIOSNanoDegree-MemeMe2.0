//
//  MeMeEditorViewController.swift
//  MemeMe2.0
//
//  Created by Aye Nyein Nyein Su on 17/05/2023.
//

import UIKit

class MeMeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    let imagePicker = UIImagePickerController()
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.5
    ]
    var memedImage = UIImage()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var pickButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        topTextField.delegate = self
        bottomTextField.delegate = self
        
    #if targetEnvironment(simulator)
        cameraButton.isEnabled = false;
    #else
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera);
    #endif
    
        prepareTextField(textField: topTextField, defaultText: "TOP")
        prepareTextField(textField: bottomTextField, defaultText: "BOTTOM")
        
        shareButton.isEnabled = false
    }
    
    func prepareTextField(textField: UITextField, defaultText: String) {
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.backgroundColor = .clear
    }

    //MARK: - ImagePickerControllerDelegate Method
    
    @IBAction func pickAnImageFromAlbum(_ sender: UIBarButtonItem) {
        
        // to pick picture
        present(imagePicker, animated: true, completion: nil)
    }
    
    // to show the picked-up photo in UIImage outlet
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImage.image = selectedPhoto
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        
        imagePicker.sourceType = .camera  //no need imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Text Field Delegate Methods
    
    @IBAction func topPressed(_ sender: UITextField) {
       
        topTextField.text = ""
        shareButton.isEnabled = true
    }
    
    @IBAction func bottomPressed(_ sender: UITextField) {
       
        bottomTextField.text = ""
        shareButton.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Keyboard & bottomTextField
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = bottomTextField.isEditing ? -getNotificationHeight(notification): 0
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getNotificationHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue//of CGRect
        return keyboardSize.cgRectValue.height
    }

  
    //MARK: - Meme Struct
    
    func save() {
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: photoImage.image!, memedImage: memedImage)
        
        // to share '[Meme]' from AppDelegate to both collection n table view
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    func generateMemedImage() -> UIImage {

        // TODO: Hide toolbar and navbar
        toolBar?.isHidden = true
        navigationBar?.isHidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // TODO: Show toolbar and navbar
        toolBar?.isHidden = false
        navigationBar?.isHidden = false

        return memedImage
    }
    
    //MARK: - Share and Cancel Button
   
    //UIActivityViewController
    @IBAction func sharePressed(_ sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        controller.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnItems: [Any]?, error: Error?) in
            self.save()
            if completed {
                self.navigationController?.popViewController(animated: true)
            }
        }
       
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
        photoImage.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.isEnabled = false
    }
    

}






