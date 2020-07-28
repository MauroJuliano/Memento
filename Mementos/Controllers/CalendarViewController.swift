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
    var months = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date()
        Calendar.delegate = self
      
        self.TableView.delegate = self
        self.TableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
        date()
        LoadList()
        
        self.list.removeAll()
        self.months.removeAll()
        self.TableView.reloadData()
      }
   
    @IBAction func btnNewtask(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle:  nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewTask") as! Newtask
        self.present(vc, animated: true, completion: nil)
    }
    
    func LoadList(){
        let uid = Auth.auth().currentUser?.uid
        self.ref = Database.database().reference().child("users").child("Listas").child(uid!)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            self.list.removeAll()
            let users = snapshot.value as! [String: AnyObject]
            for (_, value) in users{
                
                if let uidd = value["userid"] as? String{
                    if let today = value["Date"] as? String {
                        if today == self.months {
                
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
        }
     }
            self.months.removeAll()
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
                                        
                                        self.list.remove(at: indexPath.row)
                                        self.TableView.reloadData()
                                        self.keyArray = []
                                    
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
        
         self.date()
         let lista = ["Welcome", "This is your first List"]
         
        usersreference.setValue(["Itens": lista, "Date": self.months, "Hour": "12Am", "userid": uid!, "Lista": "My First List", "Alerta": "Alert"])
    
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
    
    func date(){
        //get currently date to get data from database
           let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM"
            
            let  ddString = DateFormatter()
            ddString.dateFormat = "dd"
        
            let month = formatter.string(from: currentDateTime)
            let today = ddString.string(from: currentDateTime)
            
        self.months.removeAll()
        
        if month == "01" {
            self.months = "January" + " " + today
        } else if month == "02" {
            
            self.months = "February" + " " + today
        } else if month == "03" {
            
            self.months = "March" + " " + today
        } else if month == "04" {
            
            self.months = "April" + " " + today
        } else if month == "05" {
            
            self.months = "May" + " " + today
        } else if month == "06" {
            
            self.months = "June" + " " + today
        } else if month == "07" {
            
            self.months = "July" + " " + today
            print(self.months)
        } else if month == "08" {
            
            self.months = "August" + " " + today
        } else if month == "09" {
            
            self.months = "Semptember" + " " + today
        } else if month == "10" {
            
            self.months = "October" + " " + today
        } else if month == "11" {
            
            self.months = "November" + " " + today
        } else if month == "12" {
            
            self.months  = "December" + " " + today
        }
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
        
        let mmFormatter = DateFormatter()
        mmFormatter.dateFormat = "MM"
        let ddFormatter = DateFormatter()
        ddFormatter.dateFormat = "dd"
        
        let mmString = mmFormatter.string(from: date)
        let ddString = ddFormatter.string(from: date)
        let string = formatter.string(from: date)
        
        self.months.removeAll()
        
         if mmString == "01" {
                  
                  self.months = "January"
              } else if mmString == "02" {
                  
                  self.months = "February" + " " + ddString
              } else if mmString == "03" {
                  
                  self.months = "March" + " " + ddString
              } else if mmString == "04" {
                  
                  self.months = "April" + " " + ddString
              } else if mmString == "05" {
                  
                  self.months = "May" + " " + ddString
              } else if mmString == "06" {
                  
                  self.months = "June" + " " + ddString
              } else if mmString == "07" {
                  
                  self.months = "July" + " " + ddString
              } else if mmString == "08" {
                  
                  self.months = "August" + " " + ddString
              } else if mmString == "09" {
                  
                  self.months = "Semptember" + " " + ddString
              } else if mmString == "10" {
                  
                  self.months = "October" + " " + ddString
              } else if mmString == "11" {
                  
                  self.months = "November" + " " + ddString
              } else if mmString == "12" {
                  
                  self.months  = "December" + " " + ddString
              }
        
            self.LoadList()
        
        
        
        
    }
    

}
