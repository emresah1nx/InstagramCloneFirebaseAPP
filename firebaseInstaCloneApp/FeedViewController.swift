//
//  FeedViewController.swift
//  firebaseInstaCloneApp
//
//  Created by Emre Şahin on 22.05.2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreInternal
import SDWebImage

class FeedViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource  {
    
    
    @IBOutlet weak var tableView: UITableView!
    var userEmailArray = [String] ()
    var userCommentArray = [String] ()
    var likeArray = [Int] ()
    var userImageArray = [String] ()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFirestore()
    }
    
    func getDataFromFirestore() {
        
        let fireStoreDatabase = Firestore.firestore()
        
        //  let settings = fireStoreDatabase.settings
        //  fireStoreDatabase.settings = settings
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true {
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedby = document.get("postedBY") as? String {
                            self.userEmailArray.append(postedby)
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int{
                            self.likeArray.append(likes)
                        }
                        if let imageURL = document.get("imageURL") as? String{
                            self.userImageArray.append(imageURL)
                        }
                        
                        
                        
                    }
                    self.tableView.reloadData()
                    
                }
                
            }
        }
    }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return userEmailArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath) as! FeedCeel
            cell.userEmailLabel.text = userEmailArray[indexPath.row]
            cell.likeLabel.text = String(likeArray[indexPath.row])
            cell.commentLabel.text = userCommentArray[indexPath.row]
            cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
            cell.documenIdLabel.text = documentIdArray[indexPath.row]
            return cell
        }
        
        
    }

