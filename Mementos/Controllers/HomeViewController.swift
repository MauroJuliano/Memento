//
//  HomeViewController.swift
//  Mementos
//
//  Created by Lestad on 02/07/20.
//  Copyright © 2020 Lestad. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate{


    @IBOutlet weak var btnplus: RoundedButton!
    @IBOutlet weak var celltext: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var Collection: UICollectionView!
    @IBOutlet weak var collectionSchedule: UICollectionView!
    @IBOutlet weak var lblDatefull: UILabel!
    
    var ref = DatabaseReference()
    var lista = [usersAlert]()
    var Lists = [dataS]()
    var infouser = [infos]()
    
    var namelist = ""
    var nameTeste = ""
    
    var ListName: [String] = []
    var sectionList: [String] = []
    var objectsArray = [infos]()
    var itens: [String] = []
    
    var sectionLists = ""
    var datedatabase = ""
    var namesection = ""
    @IBOutlet weak var viewDay: extensions!
    override func viewDidLoad() {
       
        viewDay.backgroundColor = UIColor(patternImage: UIImage(named: "bluehori.jpg")!)
        btnplus.backgroundColor = UIColor(patternImage: UIImage(named:"plus.png")!)
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
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        self.lblDatefull.text = formatter.string(from: currentDateTime)
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        self.lblDate.text = dateFormatter.string(from: currentDateTime)
}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let indexPath = IndexPath(row: 0, section: 0)
        Collection.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        
        remove()
        
    }
    
    func remove(){
        self.sectionLists.removeAll()
        self.namesection.removeAll()
        self.nameTeste.removeAll()
        self.ListName.removeAll()
        self.infouser.removeAll()
       
        loadData()
    }
    func loadData(){
        //get name list inside database
        
        Database
        .database()
        .reference()
        .child("users")
        .child("Listas")
        .child(Auth.auth().currentUser!.uid)
        .child("HomeList")
        .child("Listas")
        .child("Listas")
        .queryOrderedByKey()
        .observeSingleEvent(of: .value, with: { snapshot in
         
            var myArray = [String]()
            for child in snapshot.children{
          
            let snap = child as! DataSnapshot
            let objects = snap.value as! String
            
            
            self.nameTeste = objects
            self.ListName.append(objects)
            }
            self.Collection.reloadData()
//            self.loadSections()
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
            self.loadItensTest2()
            self.loadDate()
            
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
            print(datedb)
                
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
                 let userToshow = infos()
                 let info = value["info"] as? String
                 let hour = value["Hour"] as? String
                
                    userToshow.info = info
                    userToshow.hour = hour
                    
                   self.infouser.append(userToshow)
                print(self.infouser)
                               
            }
            self.collectionSchedule.reloadData()
        })
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in Collection.visibleCells{
            
            let indexPath = Collection.indexPath(for: cell)
            self.sectionLists = self.sectionList[indexPath!.row]
            remove()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == Collection {
            
        return self.ListName.count
        }
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
        
        let selectedCell = collectionView.cellForItem(at: indexPath)! as! ItensCollectionCell

        selectedCell.lblView.backgroundColor = UIColor(patternImage: UIImage(named: "bluehori.jpg")!)
        selectedCell.lblHour.backgroundColor = UIColor(patternImage: UIImage(named: "bluehori.jpg")!)

    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath)! as! ItensCollectionCell
        selectedCell.lblView.backgroundColor = UIColor.gray
    }

    
    @IBAction func btnNew(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle:  nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewHome") as! TaskhomeViewController
        vc.arrayLista = self.ListName
        self.present(vc, animated: true, completion: nil)
    }
    

}
