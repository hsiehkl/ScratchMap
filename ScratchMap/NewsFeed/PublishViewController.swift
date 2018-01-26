//
//  PublishViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/11.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import DatePickerDialog
import Firebase
import FirebaseStorage

class PublishViewController: UIViewController {

    @IBOutlet weak var textViewPlacrholder: UILabel!
    @IBOutlet weak var buttonOnImageView: UIButton!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var topVIew: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    var country: Country!
    var visitedCountries = [Country]()
    var pickerView = UIPickerView()
    var date = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIsetUp()
        
        pickerView.delegate = self
        countryTextField.inputView = pickerView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        
    }
    
    func UIsetUp() {
        topVIew.layer.borderWidth = 0.3
        topVIew.layer.borderColor = UIColor.gray.cgColor
        
        postImageView.layer.borderWidth = 1
        postImageView.layer.borderColor = UIColor(red: 170.0 / 255.0, green: 170.0 / 255.0, blue: 170.0 / 255.0, alpha: 1).cgColor
        postImageView.layer.masksToBounds = true
        
        let date = Date()
        self.dateLabel.text = DateConverter.convertToShowingDate(date: date)
        self.date = DateConverter.convertToUploadDate(date: date)
    }
    
    @IBAction func dateButtonTapped(_ sender: Any) {
        
        DatePickerDialog().show("Pick a day!", doneButtonTitle: NSLocalizedString("Done", comment: ""), cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), datePickerMode: .date) {
            (date) -> Void in
            
            if let dt = date {
                
                self.date = DateConverter.convertToUploadDate(date: dt)
                self.dateLabel.text = DateConverter.convertToShowingDate(date: dt)
            }
        }
    }
    
    @IBAction func imageViewButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: NSLocalizedString("Select an image", comment: ""), message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: NSLocalizedString("Album", comment: ""), style: .default, handler: { _ in
            self.openAlbum()
        }))

        alertController.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: { _ in
            self.openCamera()
        }))

        alertController.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))

        self.present(alertController, animated: true, completion: nil)
        
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        let user = Auth.auth().currentUser
        
        guard let userId = user?.uid else {
            self.showAlert(title: "Oops", message: NSLocalizedString("Something went wrong. Please try again.", comment: ""))
            return
        }
        
        let imageUid = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("\(imageUid).png")
        
        guard let image = self.postImageView.image else {
            showAlert(title: "Oops!", message: NSLocalizedString("Please upload an image.", comment: ""))
            return
        }
        
        if (self.countryTextField.text?.isEmpty)! {
            self.showAlert(title: "Oops!", message: NSLocalizedString("Please select a country.", comment: ""));
            return
        }
        
        if let uploadData = UIImagePNGRepresentation(image) {
        
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                guard let postImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                
                let ref =  Database.database().reference()
//                ref.keepSynced(true)
                
                let postReference = ref.child("users").child(userId).child("posts").childByAutoId()
                
                let value = ["title": self.titleTextField.text,
                             "location": self.countryTextField.text,
                             "content": self.contentTextView.text,
                             "date": self.date,
                             "imageUrl": postImageUrl] as [String: String?]
                
                postReference.setValue(value)
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("PublishViewController@@@@")
    }
}

extension PublishViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return visitedCountries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return visitedCountries[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextField.text = visitedCountries[row].name
        country = visitedCountries[row]
        
        print("country.id \(country.id)")
        
    }
}

extension PublishViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func openCamera() {

        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {

            let imagePicker = UIImagePickerController()

            imagePicker.delegate = self

            imagePicker.allowsEditing = true

            imagePicker.sourceType = .camera

            imagePicker.cameraCaptureMode = .photo

            imagePicker.modalPresentationStyle = .fullScreen

            self.present(imagePicker, animated: true, completion: nil)

        } else {

            showAlert(title: "Oops", message: NSLocalizedString("Camera is not avalible.", comment: ""))
        }
    }

    func openAlbum() {

        let imagePicker = UIImagePickerController()

        imagePicker.delegate = self

        imagePicker.allowsEditing = true

        imagePicker.sourceType = .photoLibrary

        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePicker cancel")
        dismiss(animated: true, completion: nil)
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        var selectedImageFromPicker: UIImage?

        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }

        if let selectedImage = selectedImageFromPicker {
            postImageView.image = selectedImage
        }
        
        buttonOnImageView.setImage(nil, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}


