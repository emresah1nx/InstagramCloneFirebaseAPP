//
//  SettingsViewController.swift
//  firebaseInstaCloneApp
//
//  Created by Emre Şahin on 22.05.2024.
//

import UIKit
import FirebaseAuth
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutButton(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "ToLogout", sender: nil)
        } catch {
            print("Error")
        }
    }
}
