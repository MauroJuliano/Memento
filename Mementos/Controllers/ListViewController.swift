//
//  ListViewController.swift
//  Mementos
//
//  Created by Lestad on 13/07/20.
//  Copyright © 2020 Lestad. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase


class listviewcontroller: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    
    @IBOutlet weak var TxtName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var namelist = "txt"
    var DateL = ""
    var HourL = ""
    var object = ""
    var ObjectsArray = [String]()
    var keyArray:[String] = []
    var complete:[String] = []
    var completeString = ""
    var ref = Database.database().reference()
    var Alerta = ""
    var completeds: [String] = []
    var CompletedData: [String] = []
    var selectedRow = ""
    var keyCompled: [String] = []
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        TxtName.text! = namelist
        loadData()
        loadAlerta()
        loadCompl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadData()
        loadCompl()
    }
    
    func loadCompl(){
        Database
        .database()
        .reference()
        .child("users")
        .child("Listas")
        .child(Auth.auth().currentUser!.uid)
        .child(namelist)
        .child("Completed")
        .queryOrderedByKey()
        .observeSingleEvent(of: .value, with: { snapshot in
            self.completeds.removeAll()
            
            var myArray = [String]()
            for child in snapshot.children{
                let snap = child as? DataSnapshot
                let objects = snap?.value as! String
                
                myArray.append(objects)
            self.completeds.append(objects)
            
            }
            self.tableView.reloadData()
        })
    }
    
    func loadData(){
        Database
        .database()
        .reference()
        .child("users")
        .child("Listas")
        .child(Auth.auth().currentUser!.uid)
        .child(namelist)
        .child("Itens")
        .queryOrderedByKey()
        .observeSingleEvent(of: .value, with: { snapshot in
            self.ObjectsArray.removeAll()
            
            var myArray = [String]()
            for child in snapshot.children{
                let snap = child as? DataSnapshot
                let objects = snap?.value as! String
                
                myArray.append(objects)
            self.ObjectsArray.append(objects)
            
            }
            self.loadCompl()
            self.tableView.reloadData()
        })
    }
    
    func loadAlerta(){
           //get data from database
           Database
           .database()
           .reference()
           .child("users")
           .child("Listas")
           .child(Auth.auth().currentUser!.uid)
            .child(namelist)
           .queryOrderedByKey()
           .observeSingleEvent(of: .value, with: { snapshot in
            self.Alerta.removeAll()
            let users = snapshot.value as! [String: AnyObject]
              
            for(_, value) in users{
                  
                   if let alert = value["Alerta"] {
                       let userToshow = usersAlert()
                       if let date = value["Date"] as? String, let hour = value["Hour"] as? String, let lista = value["Lista"] as? String, let Alert = value["Alerta"] as? String {
                        
                           userToshow.date = date
                           userToshow.hour = hour
                           userToshow.lista = lista
                           userToshow.Alerta = Alert
                           
                        self.Alerta = userToshow.Alerta
                           
                       }
                   }
               }
               
           })
       }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {(action, view, completion) in
                    
                        self.getAllKeys()
                                    let when = DispatchTime.now() + 1
                                    DispatchQueue.main.asyncAfter(deadline: when, execute: {
                                        Database
                                        .database()
                                        .reference()
                                        .child("users")
                                        .child("Listas")
                                        .child(Auth.auth().currentUser!.uid)
                                        .child(self.namelist)
                                        .child("Itens")
                                            .child(self.keyArray[indexPath.row]).setValue(nil)
                                        
                                        self.ObjectsArray.remove(at: indexPath.row)
                                        self.tableView.reloadData()
                                        self.keyArray = []
                        })
            self.loadData()
            self.tableView.reloadData()
                    }
        action.image = #imageLiteral(resourceName: "trash.png")
        action.backgroundColor = UIColor(patternImage: UIImage(named: "blue.jpg")!)
        return action
    }
      func numberOfSections(in tableView: UITableView) -> Int {
          return 2
      }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        var complete = completeAction(at: indexPath)
        var recovery = rescueAction(at: indexPath)
        let section1 = indexPath.section == 0 ? complete : recovery
        return UISwipeActionsConfiguration (actions: [section1])
      
    }
    func rescueAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Completed") {(complete, view, completion) in

            self.completeString = self.completeds[indexPath.row]
            //       self.complete = [self.completeString]
            self.ObjectsArray.append(self.completeString)
//                   _ = self.complete.joined(separator: ", ")
            self.completeItens()
            self.recoveryData(at: indexPath)
                   completion(true)
               
               }
               
               action.image = #imageLiteral(resourceName: "refresh.png")
               action.backgroundColor = UIColor(patternImage: UIImage(named: "blue.jpg")!)
               return action
    }
    func recoveryData(at indexPath: IndexPath){
        
        self.getAllKeys()
        let when = DispatchTime.now() + 1
               DispatchQueue.main.asyncAfter(deadline: when, execute: {
                                               
               Database
               .database()
               .reference()
               .child("users")
               .child("Listas")
               .child(Auth.auth().currentUser!.uid)
               .child(self.namelist)
               .child("Completed")
               .child(self.keyCompled[indexPath.row]).setValue(nil)
                                                           
               self.completeds.remove(at: indexPath.row)
               self.tableView.reloadData()
               self.keyCompled = []
                                  
               })
               self.loadData()
               self.tableView.reloadData()
        
    }
    func deleteFrom(at indexPath: IndexPath){
        self.getAllKeys()
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
                                        
        Database
        .database()
        .reference()
        .child("users")
        .child("Listas")
        .child(Auth.auth().currentUser!.uid)
        .child(self.namelist)
        .child("Itens")
        .child(self.keyArray[indexPath.row]).setValue(nil)
                                                    
        self.ObjectsArray.remove(at: indexPath.row)
        self.tableView.reloadData()
        self.keyArray = []
                           
        })
        self.loadData()
        self.tableView.reloadData()
    }
    
    func completeAction(at indexPath: IndexPath) -> UIContextualAction {
        
        
        let action = UIContextualAction(style: .destructive, title: "Completed") {(complete, view, completion) in
            
            self.completeString = self.ObjectsArray[indexPath.row]
            self.complete = [self.completeString]
            self.completeds.append(self.completeString)
            _ = self.complete.joined(separator: ", ")
            
            self.loadAlerta()
            self.completeItens()
            self.deleteFrom(at: indexPath)
            completion(true)
        
        }
        
        action.image = #imageLiteral(resourceName: "check.png")
        action.backgroundColor = UIColor(patternImage: UIImage(named: "blue.jpg")!)
        return action
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    @IBAction func btnAdd(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ContentView") as! contentViewController
        vc.name = self.namelist
        vc.Date = self.DateL
        vc.Hour = self.HourL
        vc.objectsl = self.ObjectsArray
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        loadData()
    }
    
    func getAllKeys(){
        Database
        .database()
        .reference()
        .child("users")
        .child("Listas")
        .child(Auth.auth().currentUser!.uid)
        .child(namelist)
        .child("Itens")
        .queryOrderedByKey()
        .observeSingleEvent(of: .value, with: { snapshot in
            self.ObjectsArray.removeAll()
            
            var myArray = [String]()
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let objects = snap.value as! String
                let key = snap.key as! String
                
                myArray.append(objects)
                
                self.keyArray.append(key)
                print(self.keyArray)
                
            }
        })
        Database
               .database()
               .reference()
               .child("users")
               .child("Listas")
               .child(Auth.auth().currentUser!.uid)
               .child(namelist)
               .child("Completed")
               .queryOrderedByKey()
               .observeSingleEvent(of: .value, with: { snapshot in
                   self.ObjectsArray.removeAll()
                   
                   var myArray = [String]()
                   for child in snapshot.children{
                       let snap = child as! DataSnapshot
                       let objects = snap.value as! String
                       let key = snap.key as! String
                       
                       myArray.append(objects)
                       
                       self.keyCompled.append(key)
                       print(self.keyCompled)
                       
                   }
               })
    }
    
    func completeItens() {
        
         self.ref = Database.database().reference()
          
          var usersreference = ref.child("users")
              .child("Listas")
              .child(Auth.auth().currentUser!.uid)
              .child(namelist)

        let uid = Auth.auth().currentUser?.uid
        let alerts = self.Alerta

        if alerts == "Alert"{
            usersreference.setValue(["Itens": self.ObjectsArray, "Date": self.DateL, "Hour": self.HourL, "userid": uid!, "Lista": self.namelist, "Completed": self.completeds, "Alerta": "Alert"])
        } else{
            usersreference.setValue(["Itens": self.ObjectsArray, "Date": self.DateL, "Hour": self.HourL, "userid": uid!, "Lista": self.namelist, "Completed": self.completeds])
        }
               
    }
  
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return ""
        }else {
            return "Completed"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
        return self.ObjectsArray.count
        }
        return self.completeds.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        let lista = indexPath.section == 0 ? ObjectsArray[indexPath.row] : self.completeds[indexPath.row]
        cell.textLabel?.text = lista
        cell.textLabel?.text = "\(lista)"
        return cell
    }
    
    
    
}
