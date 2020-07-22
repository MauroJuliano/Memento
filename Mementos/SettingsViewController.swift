//
//  SettingsViewController.swift
//  Mementos
//
//  Created by Lestad on 21/07/20.
//  Copyright © 2020 Lestad. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class SettingsViewController: UIViewController {

    @IBOutlet weak var imageprofile: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    var dataSend = ""
    var userArray = [users2]()
    
    override func viewDidLoad() {
        loadData()
        super.viewDidLoad()
        ImgProfile()
        
        // Do any additional setup after loading the view.
    }
    func ImgProfile() {
        // imgview configurations
        imageprofile?.layer.cornerRadius = (imageprofile?.frame.size.width ?? 0.0) / 2
        imageprofile?.clipsToBounds = true
        imageprofile?.layer.borderWidth = 3.0
        imageprofile?.layer.borderColor = UIColor.white.cgColor
    }
    func loadData(){
           //get user's data from database

        Database
        .database()
        .reference()
        .child("users")
        .child(Auth.auth().currentUser!.uid)
        .queryOrderedByKey()
        .observeSingleEvent(of: .value, with: { snapshot in
            if let users = snapshot.value as? [String: AnyObject]{
              if let alert = users["UserID"] {
              let userToshow = users2()
          
              if let email = users["Email"] as? String, let userID = users["UserID"] as? String, let username = users["Name"] as? String {
                         
                      
                      userToshow.email = email
                      userToshow.userID = userID
                      userToshow.name = username


                      self.userArray.append(userToshow)
                        
                      self.name.text! = userToshow.name
                      self.email.text! = userToshow.email


                     }
                 }
            }
        })
       }
        
    @IBAction func btnSignOut(_ sender: Any) {
        // button to sign off user
        try! Auth.auth().signOut()
        
        // call the first view controller after sign out
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let register = storyboard.instantiateViewController(withIdentifier: "Main")
        register.modalPresentationStyle = .fullScreen
      
        self.present(register, animated: true, completion: nil)
        
    }
    
    @IBAction func btnSupport(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let register = storyboard.instantiateViewController(withIdentifier: "About") as! AboutViewController
        self.dataSend = ""
        self.dataSend = "Support"
        register.dataReceive = self.dataSend
        self.present(register, animated: true, completion: nil)
    }
    @IBAction func btnAbout(_ sender: Any) {
        //button to about
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let register = storyboard.instantiateViewController(withIdentifier: "About") as! AboutViewController
        self.dataSend = ""
        self.dataSend = "About"
        register.dataReceive = self.dataSend
        self.present(register, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
