//
//  registerViewController.swift
//  Mementos
//
//  Created by Lestad on 02/07/20.
//  Copyright © 2020 Lestad. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class registerViewController: UIViewController {

    @IBOutlet weak var TxtEmail: UITextField!
    @IBOutlet weak var TxtNickname: UITextField!
    @IBOutlet weak var TxtConfirm: customUITextField!
    
    @IBOutlet weak var BRegister: RoundedButton!
    @IBOutlet weak var TxtPassword: UITextField!
    
    var objectsArray: [String] = []
    var ref: DatabaseReference!

    override func viewDidLoad() {
        
        placholders()
        
        super.viewDidLoad()
        BRegister.backgroundColor = UIColor(patternImage: UIImage(named: "blue.jpg")!)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blue3.jpg")!)
        // Do any additional setup after loading the view.
    }
    func placholders(){
        //confirugation placeholders
        TxtNickname.attributedPlaceholder = NSAttributedString(string: "Name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        TxtEmail.attributedPlaceholder = NSAttributedString(string: "Email",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        TxtPassword.attributedPlaceholder = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        TxtConfirm.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    @IBAction func BRegister(_ sender: Any) {
        // get data from textfield and save in databse
        let signUpManager = FirebaseAuthManager()
        if let email = TxtEmail.text, let nickname = TxtNickname.text, let password = TxtPassword.text {
            signUpManager.createUser(email: email, password: password) {[weak self] (success) in
                
                
               self?.ref = Database.database().reference()
                let usersReference = self!.ref.child("users")
                
            
                if let uid = Auth.auth().currentUser?.uid {
                    
                let newReference = usersReference.child(uid)
                newReference.setValue(["Name": self?.TxtNickname.text!, "Email": self?.TxtEmail.text!, "UserID": uid])
                self!.registerList()
                }
                
                guard case let `self` = self else {return}
                var message: String = ""
                if (success) {
                    message = "User was sucessfully created"
                } else {
                    message = "There was an error."
                }
                
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "Tabbar") as! tabbarcontroller
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true, completion: nil)
               
                
            }
        }
    }
    func registerList() {
        //register one list when register new user
        self.ref = Database.database().reference()
               
               var usersreference = ref.child("users")
                .child("Listas")
                .child(Auth.auth().currentUser!.uid)
                .child("My First List")

             let uid = Auth.auth().currentUser?.uid
        self.objectsArray = ["Welcome", "This is your first Lista"]
        usersreference.setValue(["Itens": self.objectsArray, "Date": "27 July", "Hour": "12Am", "userid": uid!, "Lista": "My First List", "Alerta": "Alert"])
             
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
