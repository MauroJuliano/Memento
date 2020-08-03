//
//  HomeViewController.swift
//  Mementos
//
//  Created by Lestad on 02/07/20.
//  Copyright © 2020 Lestad. All rights reserved.
//

import UIKit
import FSCalendar
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate{


    @IBOutlet weak var btnplus: RoundedButton!
    @IBOutlet weak var celltext: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var Collection: UICollectionView!
    @IBOutlet weak var collectionSchedule: UICollectionView!
    @IBOutlet weak var lblDatefull: UILabel!
    
    @IBOutlet weak var viewbtn: extensions!
    @IBOutlet weak var btndate: RoundedButton!
    var ref = DatabaseReference()
    var lista = [usersAlert]()
    var Lists = [dataS]()
    var infouser = [infos]()
    var dayz = [day]()
    var namelist = ""
    var nameTeste = ""
    @IBOutlet weak var today: UILabel!
    var dataToday = ""
    var ListName: [String] = []
    var sectionList: [String] = []
    var objectsArray = [infos]()
    var itens: [String] = []
    var teste = ""
    var sectionLists = ""
    var datedatabase = ""
    var namesection = ""
    
    @IBOutlet weak var viewDay: extensions!
    override func viewDidLoad() {
       

        btnplus.backgroundColor = UIColor(patternImage: UIImage(named:"plus.png")!)
        viewbtn.backgroundColor = UIColor(patternImage: UIImage(named:"bluehori.jpg")!)
        super.viewDidLoad()
        Collection.delegate = self
        Collection.dataSource = self
        collectionSchedule.delegate = self
        collectionSchedule.dataSource = self

        date()
        
        self.view.addSubview(Collection)
        
    }

    
    func date(){
        //get and set data/hour
       let currentDateTime = Date()
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        let mmString : DateFormatter = DateFormatter()
        mmString.dateFormat = "MM"
        
        self.lblDatefull.text = formatter.string(from: currentDateTime)
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
       
        self.today.text = dateFormatter.string(from: currentDateTime)
        
        var month = mmString.string(from: currentDateTime)
        var day = dateFormatter.string(from: currentDateTime)
        var weekday = formatter.string(from: currentDateTime)
        var dayT = ""
        self.dataToday = dateFormatter.string(from: currentDateTime)
        
        if month == "01" {
            self.lblDatefull.text = weekday + ", " + "January" + " " + day
            
            self.dataToday = "January" + " " + day
        } else if month == "02" {
            
            self.lblDatefull.text = weekday + ", " + "February" + " " + day
            self.dataToday = "February" + " " + day
        } else if month == "03" {
            
            self.lblDatefull.text = weekday + ", " + "March" + " " + day
            self.dataToday = "March" + " " + day
        } else if month == "04" {
            
            self.lblDatefull.text = weekday + ", " + "April" + " " + day
            self.dataToday = "April" + " " + day
        } else if month == "05" {
            
            self.lblDatefull.text = weekday + ", " + "May" + " " + day
            self.dataToday = "May" + " " + day
        } else if month == "06" {
            
            self.lblDatefull.text = weekday + ", " + "June" + " " + day
            self.dataToday = "June" + " " + day
        } else if month == "07" {
            
            self.lblDatefull.text = weekday + ", " + "July" + " " + day
            self.dataToday = "July" + " " + day
        } else if month == "08" {
            
            self.lblDatefull.text = weekday + ", " + "August" + " " + day
            self.dataToday = "August" + " " + day
        } else if month == "09" {
            
            self.lblDatefull.text = weekday + ", " + "Semptember" + " " + day
            self.dataToday = "Semptember" + " " + day
        } else if month == "10" {
            
            self.lblDatefull.text = weekday + ", " + "October" + " " + day
            self.dataToday = "October" + " " + day
        } else if month == "11" {
            
            self.lblDatefull.text = weekday + ", " + "November" + " " + day
            self.dataToday = "November" + " " + day
        } else if month == "12" {
            
            self.lblDatefull.text = weekday + ", " + "December" + " " + day
            self.dataToday = "December" + " " + day
        }
        
}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let indexPath = IndexPath(row: 0, section: 0)
        Collection.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        remove()
        
    }
    
    func remove(){
        self.sectionLists.removeAll()
        self.sectionList.removeAll()
        self.namesection.removeAll()
        self.nameTeste.removeAll()
        self.ListName.removeAll()
        self.infouser.removeAll()
       
        loadData()
    }
    func loadData(){
        //get name list inside database
        let data = self.dataToday
        Database
        .database()
        .reference()
        .child("users")
        .child("Listas")
        .child(Auth.auth().currentUser!.uid)
        .child("HomeList")
        .child("Listas")
        .child(data)
        .child("Listas")
        .queryOrderedByKey()
        .observeSingleEvent(of: .value, with: { snapshot in

            var myArray = [String]()
            for child in snapshot.children{

            let snap = child as! DataSnapshot
            let objects = snap.value as! String

            self.nameTeste = objects
            self.ListName.append(objects)
                print(self.nameTeste)
            }
            self.loadSections()
        })
    }

        func loadSections(){
         //get array list inside de main list
         self.namesection.removeAll()
            
          Database
         .database()
         .reference()
         .child("users")
         .child("Listas")
         .child(Auth.auth().currentUser!.uid)
         .child("HomeList")
         .child(self.nameTeste)
         .child("Itens")
         .child("itens")
         .child("section")
         .child("sections")
         .queryOrderedByKey()
         .observeSingleEvent(of: .value, with: { snapshot in
           
            var myArray = [String]()
            for child in snapshot.children{
                           
            let snap = child as? DataSnapshot
            let objects = snap?.value as! String

            myArray.append(objects)
            self.sectionList.append(objects)
            self.namesection = objects
            
            }
            self.loadDate()
            self.loadItensTest2()
         })
            
     }
    
      func loadDate(){
            //use de array list to get more data
           
             Database
            .database()
            .reference()
            .child("users")
            .child("Listas")
            .child(Auth.auth().currentUser!.uid)
            .child("HomeList")
            .child(self.nameTeste)
            .child("Itens")
            .child("itens")
            .child("Date")
            .queryOrderedByKey()
            .observeSingleEvent(of: .value, with: { snapshot in

            let users = snapshot.value as! [String: AnyObject]
               
            var datedb = users["Date"] as! String
            
            self.datedatabase = datedb
            })
        }
    
    func loadItensTest2(){
        //use de array list to get more data
        let uid = Auth.auth().currentUser?.uid
        self.ref = Database.database().reference().child("users").child("Listas").child(uid!).child("HomeList").child(self.nameTeste).child("Itens").child("itens").child("Listas")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            self.infouser.removeAll()
            
            let users = snapshot.value as! [String: AnyObject]
            
            for(_, value) in users{
                print(self.dataToday)
                print("data today")
                if let day = value["Day"] as? String {
    
                if day == self.dataToday {
                    
                 let userToshow = infos()
                 let info = value["info"] as? String
                 let hour = value["Hour"] as? String
               
                    userToshow.info = info
                    userToshow.hour = hour
                   
                   self.infouser.append(userToshow)
                }
            }
            }
//            self.loadSections()
            self.Collection.reloadData()
            self.collectionSchedule.reloadData()
        })
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in Collection.visibleCells{

            let indexPath = Collection.indexPath(for: cell)
            self.nameTeste = self.ListName[indexPath!.row]
            remove()
            
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == Collection {
            
        return self.ListName.count
        }
        print(self.infouser.count)
        return self.infouser.count
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == Collection {
        //Card Collection's settings
        let cell = Collection.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! CardCollectionCell
    
            cell.Carview.backgroundColor = UIColor(patternImage: UIImage(named: "bluehori.jpg")!)
            cell.Nametask.text = self.ListName[indexPath.row]
            
            return cell
        }
        
        let cell2 = collectionSchedule.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! ItensCollectionCell

        cell2.Taskname.text = self.infouser[indexPath.row].info
        cell2.Itenshour.text = self.infouser[indexPath.row].hour
        
        return cell2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == Collection{
             self.nameTeste.removeAll()
                       let name = self.ListName[indexPath.row]
                       self.nameTeste = name
                       self.ListName.removeAll()
                       self.loadSections()
//            self.remove()
        }
        
        if collectionView == collectionSchedule{
                  print("Collection schedule")
                           
                        let selectedCell = collectionView.cellForItem(at: indexPath)! as! ItensCollectionCell

            
            selectedCell.lblView.backgroundColor = UIColor(patternImage: UIImage(named: "bluehori.jpg")!)
                        selectedCell.lblHour.backgroundColor = UIColor(patternImage: UIImage(named: "bluehori.jpg")!)
            }
       

    }

    
    @IBAction func btnNew(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle:  nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewHome") as! TaskhomeViewController
        vc.arrayLista = self.ListName
        self.present(vc, animated: true, completion: nil)
    }
    

}
