//
//  CalendarViewController.swift
//  Mementos
//
//  Created by Lestad on 02/07/20.
//  Copyright © 2020 Lestad. All rights reserved.
//

import UIKit
import FSCalendar
import FirebaseDatabase
import FirebaseAuth

class CalendarViewController: UIViewController, FSCalendarDelegate, UITableViewDataSource, UITableViewDelegate {

    
    var ref = DatabaseReference()
    
    @IBOutlet weak var TxtItem: UILabel!
   
    @IBOutlet weak var Deldata: UIButton!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet var Calendar: FSCalendar!
    var list = [todo]()
    var emptyArray = ""
    var name = ""
    var keyArray:[String] = []
    var join: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Calendar.delegate = self
      
        self.TableView.delegate = self
        self.TableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
        LoadList()
        self.list.removeAll()
       
        self.TableView.reloadData()   // ...and it is also visible here.
      }
   
    func LoadList(){
        let uid = Auth.auth().currentUser?.uid
        self.ref = Database.database().reference().child("users").child("Listas").child(uid!)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
          
            
            let users = snapshot.value as! [String: AnyObject]
            for (_, value) in users{
                
                if let uidd = value["userid"] as? String{
                    
                    if uid == Auth.auth().currentUser?.uid{
                       
                        let userToshow = todo()
                        if let listaname = value["Lista"] as? String,
                            let Date = value["Date"] as? String,
                            let Hour = value["Hour"] as? String{
                            
                            userToshow.Lista = listaname
                            userToshow.Date = Date
                            userToshow.Hour = Hour
                        
                            self.list.append(userToshow)
                            self.name = userToshow.Lista
                            self.emptyArray = userToshow.Lista
                            
                        }
                    }
                }
            }
            self.TableView.reloadData()
    })
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return list.count
       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = TableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel!.text = list[indexPath.row].Lista
        
        return cell

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
                                            .child(self.list[indexPath.row].Lista).removeValue()
//                                        
//                                        self.list.remove(at: indexPath.row)
//                                        self.TableView.reloadData()
//                                        self.keyArray = []
//                                        

                        })
            
            
            if self.emptyArray == ""{
                self.list.removeAll()
                self.emptyArray.removeAll()
                self.registerList()
            }
            self.LoadList()
            }
        action.image = #imageLiteral(resourceName: "trash.png")
        action.backgroundColor = UIColor(patternImage: UIImage(named: "blue.jpg")!)
        return action
    }
    func registerList() {
         //register one list when register new user
         self.ref = Database.database().reference()
                
                var usersreference = ref.child("users")
                 .child("Listas")
                 .child(Auth.auth().currentUser!.uid)
                 .child("My First List")

              let uid = Auth.auth().currentUser?.uid
        
        
         let lista = ["Welcome", "This is your first List"]
         
         usersreference.setValue(["Itens": lista, "Date": "27 July", "Hour": "12Am", "userid": uid!, "Lista": "My First List", "Alerta": "Alert"])
    
     }
    func getAllKeys(){
        Database
        .database()
        .reference()
        .child("users")
        .child("Listas")
        .child(Auth.auth().currentUser!.uid)
        .queryOrderedByKey()
        .observeSingleEvent(of: .value, with: { snapshot in
            self.list.removeAll()
            
            var myArray = [String]()
            let users = snapshot.value as? [String: AnyObject]
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let objects = snap.value
                let key = snap.key
                self.keyArray.append(key)
                self.join = []
                let joined = self.keyArray.joined(separator: ", ")
                
                self.join.append(joined)
                
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle:  nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "ListaView") as! listviewcontroller
        vc.namelist = list[indexPath.row].Lista
        vc.DateL = list[indexPath.row].Date
        vc.HourL = list[indexPath.row].Hour
        self.present(vc, animated: true, completion: nil)
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-YYYY"
        let string = formatter.string(from: date)
        print("\(string)")
        
        
        
        
    }
    

}
