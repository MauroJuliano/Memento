//
//  LoginViewController.swift
//  Mementos
//
//  Created by Lestad on 02/07/20.
//  Copyright © 2020 Lestad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var Txtpassword: UITextField!
    @IBOutlet weak var Txtemail: UITextField!
    @IBOutlet weak var LogView: extensions!
    @IBOutlet weak var btnLogin: RoundedButton!
    
    override func viewDidLoad() {
        
        LogView.backgroundColor = UIColor(patternImage: UIImage(named: "blue.jpg")!)
        btnLogin.backgroundColor = UIColor(patternImage: UIImage(named: "blue.jpg")!)
        
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func Btnregist(_ sender: Any) {
        
        
        
    }
    @IBAction func btnLogin(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: self.Txtemail.text!, password: self.Txtpassword.text!) { [weak self] user, error in
                 //guard let strongSelf = self else { return }
                 if error != nil{
                     print("me")
                     print(error!.localizedDescription)
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let poperror = storyboard.instantiateViewController(identifier: "popwarning") as! popviewcontroller
                    //poperror.modalPresentationStyle = .fullScreen
                    
                    self?.present(poperror, animated: true, completion: nil)
                    
                    
                     return
                 }
             let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
             let Login = storyboard.instantiateViewController(withIdentifier: "Tabbar") as! tabbarcontroller
            
            Login.modalPresentationStyle = .fullScreen
            self?.present(Login, animated: true, completion: nil)

        }
}
}
