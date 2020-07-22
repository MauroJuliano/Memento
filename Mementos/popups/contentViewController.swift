//
//  contentViewController.swift
//  Mementos
//
//  Created by Lestad on 13/07/20.
//  Copyright © 2020 Lestad. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class contentViewController: UIViewController{
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var popContent: extensions!
    @IBOutlet weak var TxtTask: UITextField!
    var name = "txt"
    var Date = ""
    var Hour = ""
    var objectsl = [String]()
    var itens = [String]()
    var keyArray:[String] = []
    
    override func viewDidLoad() {
        // pop up to new task
        getAllKeys()
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        popContent.backgroundColor = UIColor.white
    }
   
    func getAllKeys(){
        //Get keys from array
           Database
           .database()
           .reference()
           .child("users")
           .child("Listas")
           .child(Auth.auth().currentUser!.uid)
           .child(name)
           .child("Itens")
           .queryOrderedByKey()
           .observeSingleEvent(of: .value, with: { snapshot in
              
               var myArray = [String]()
               for child in snapshot.children{
                   let snap = child as! DataSnapshot
                   let objects = snap.value as! String
                   let key = snap.key as! String
                   
                   self.keyArray.append(key)
               }
           })
       }
    
    func getData(){
        //save new task on database
        self.ref = Database.database().reference()
        
        var usersreference = ref.child("users")
            .child("Listas")
            .child(Auth.auth().currentUser!.uid)
            .child(name)
            itens.append(self.TxtTask.text!)
            itens.append(contentsOf: self.objectsl)
               print(itens)
               let joined = itens.joined(separator: ", ")
               self.TxtTask.text = joined
      
            
        let uid = Auth.auth().currentUser?.uid
        
        usersreference.setValue(["Itens": self.itens, "Date": self.Date, "Hour": self.Hour, "userid": uid!, "Lista": self.name])
       }
    
    @IBAction func btncancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnOkay(_ sender: Any) {
        getData()
        self.dismiss(animated: true, completion: nil)
    }
    
}
