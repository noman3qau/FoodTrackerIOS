//
//  ViewController.swift
//  TestIOS
//
//  Created by EvampSaanga on 3/29/18.
//  Copyright © 2018 EvampSaanga. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    @IBOutlet weak var inputItemField: UITextField!
    @IBOutlet weak var defaultImage: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value either passed 'by MealTableViewControler' in
     'prepare(for:sender:)'
     or control as part of adding new meal
    */
    
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Handle UI text field through delegate
        inputItemField.delegate=self
        
        // Setup view if editing an existing Meal
        if let meal = meal{
            
            navigationItem.title=meal.name
            inputItemField.text=meal.name
            defaultImage.image=meal.photo
            ratingControl.rating=meal.rating
            
        }
        
        // Enable saveButton only if text field has a valid Meal name.
        updateSavedButtonState()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide keyboard
        textField.resignFirstResponder()
        return true
    }

    //MARK: UIImagePickerDelegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss image picker if user click cancel
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        // The info directory may contail multiple reperesentation of image. You want to use origional
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as?
        UIImage else {
            fatalError("Expected a directory containing an image, But was providing the following: \(info)")
        }
        
        // Set image view to display selected image
        defaultImage.image=selectedImage
        
        // Dismiss image picker
        dismiss(animated: true, completion: nil)

    }
    
    //MARK: Navigation
    
    // This method lets you configure a view controler before it's presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controler only when the save button is pressed
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The saved button was not pressed, Cancelling", log: OSLog.default,type: .debug)
            return
        }
        
        let name = inputItemField.text ?? ""
        let photo = defaultImage.image
        let rating = ratingControl.rating
     
        // Set the meal to be passed to MealTableViewControler after unwind segue
        meal = Meal(name: name,photo: photo,rating: rating)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide keyboard
        inputItemField.resignFirstResponder()
        
        // UIImagePickerViewController is a view controller that let user to picker a media from their photo library
        let imagePickerController=UIImagePickerController()
        
        //Only allow photo to pick, not take
        imagePickerController.sourceType = .photoLibrary
        
        // Make view controller is notified when uset pick an image
        imagePickerController.delegate=self
        
        present(imagePickerController, animated:true, completion:nil)
        
    }
    
    @IBAction func pressedCancel(_ sender: Any){
//        self.navigationController?.popViewController(animated: true);

        // Depending on style of presentation (modal or push presentation), this view controller needs to dismiss view in two different  ways
        let isPresentedInAddMealView = presentingViewController is UINavigationController
        
        if isPresentedInAddMealView {
            dismiss(animated: true, completion: nil)
        }else if self.navigationController != nil {
            navigationController?.popViewController(animated: true)
        }else{
            fatalError("The MealViewController is not inside the Navigation controller.")
        }
        
    }
    
    
    //MARK: UIFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable saved buttin while Editing
        saveButton.isEnabled=false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSavedButtonState()
        navigationItem.title = inputItemField.text
    }
    
    //MARK: Private Methods
    private func updateSavedButtonState(){
        // Disable saveButton if text Field is empty
        
        let text = inputItemField.text ?? ""
        
        saveButton.isEnabled = !text.isEmpty
        
    }
    
}

