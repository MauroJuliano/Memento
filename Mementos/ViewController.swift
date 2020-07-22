//
//  ViewController.swift
//  Mementos
//
//  Created by Lestad on 02/07/20.
//  Copyright © 2020 Lestad. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blue.jpg")!)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let uid = Auth.auth().currentUser
        
        
        if uid != nil{
          let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
           let Login = storyboard.instantiateViewController(withIdentifier: "Tabbar") as! tabbarcontroller
            print("isnide uid")
            Login.modalPresentationStyle = .fullScreen
            //self.view.window?.rootViewController = Login
                 self.present(Login, animated: true, completion: nil)
        }
    }
  
    @IBAction func btnnext(_ sender: Any) {
       
        //button to login scene
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
       
            let Login = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
//            Login.modalPresentationStyle = .fullScreen
            self.present(Login, animated: true, completion: nil)
        
            
    }
    @IBAction func btnRegs(_ sender: Any) {
    //register new user
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let register = storyboard.instantiateViewController(withIdentifier: "Register")
    self.present(register, animated: true, completion: nil)
        
    }
    
    
}

