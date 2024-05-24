//
//  UploadViewController.swift
//  firebaseInstaCloneApp
//
//  Created by Emre Şahin on 22.05.2024.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreInternal


class UploadViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detayText: UITextView!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageTapRecagnizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTapRecagnizer)
    }
    
    func makeAlert(titleInput:String , messageInput:String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func uploadButton(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReferences = storage.reference()
        
        let mediaFolder = storageReferences.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.1) {
            
            let uuid = UUID().uuidString
            
            let imageReferences = mediaFolder.child("\(uuid).jpg")
            imageReferences.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                }
                else {
                    imageReferences.downloadURL { (url, error) in
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            //DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            
                            let firestorePost = ["imageURL" : imageUrl!,"postedBY" : Auth.auth().currentUser!.email!,"postComment" : self.detayText.text!,"date" : FieldValue.serverTimestamp(),"likes" : 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (Error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                                    

                                } else {
                                    
                                    self.imageView.image = UIImage(named: "selectImage")
                                    self.detayText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                                })
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                    }
                    
                }
            }
        }
        
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    @objc func selectImage() {

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        uploadButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

}
