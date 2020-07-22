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
    var namelist = ""
    @IBOutlet weak var lblDatefull: UILabel!
    var lista = [usersAlert]()
    var objectsArray: [String] = []
    var itens: [String] = []
    
    @IBOutlet weak var viewDay: extensions!
    override func viewDidLoad() {
    loadData()
       
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
        loadData()
        
    }
    func loadData(){
        //get data from database
        Database
        .database()
        .reference()
        .child("users")
        .child("Listas")
        .child(Auth.auth().currentUser!.uid)
        .queryOrderedByKey()
        .observeSingleEvent(of: .value, with: { snapshot in
            self.lista.removeAll()
            if let users = snapshot.value as? [String: AnyObject]{
          
            for(_, value) in users{
                
                if let alert = value["Alerta"] {
                    let userToshow = usersAlert()
                    if let date = value["Date"] as? String, let hour = value["Hour"] as? String, let lista = value["Lista"] as? String, let Alert = value["Alerta"] as? String {
                        userToshow.date = date
                        userToshow.hour = hour
                        userToshow.lista = lista
                        userToshow.Alerta = Alert
                        
                        self.lista.append(userToshow)
                        self.namelist = userToshow.lista
                        
                    }
                }
            }
            }
            self.loadItens()
           self.Collection.reloadData()
        })
    }
    
    func loadItens(){
        //get array itens (inside lista) from database
        
        Database
        .database()
        .reference()
        .child("users")
        .child("Listas")
        .child(Auth.auth().currentUser!.uid)
        .child(self.namelist)
        .child("Itens")
        .queryOrderedByKey()
        .observeSingleEvent(of: .value, with: { snapshot in
            
            self.objectsArray.removeAll()
            
            var myArray = [String]()
            for child in snapshot.children{
                
                let snap = child as? DataSnapshot
                print(snap?.description)
                let objects = snap?.value as! String

                myArray.append(objects)
                self.objectsArray.append(objects)
            
                
            }
            self.collectionSchedule.reloadData()
        })
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in Collection.visibleCells{
            let indexPath = Collection.indexPath(for: cell)
            
            print(indexPath)

            self.namelist = self.lista[indexPath!.row].lista
            print(self.namelist)
            loadItens()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == Collection {
            return self.lista.count
        }
        return self.objectsArray.count
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == Collection {
            //Card Collection's settings
        let cell = Collection.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! CardCollectionCell
    
            cell.Carview.backgroundColor = UIColor(patternImage: UIImage(named: "bluehori.jpg")!)
            cell.Nametask.text = lista[indexPath.row].lista
            cell.hourTask.text = lista[indexPath.row].hour
            
            return cell
        }
        let cell2 = collectionSchedule.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! ItensCollectionCell

            cell2.Taskname.text = self.objectsArray[indexPath.row]
        
        
        return cell2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.namelist.removeAll()
//        print(self.lista[indexPath.row].lista)
//        self.namelist = self.lista[indexPath.row].lista
        
        let selectedCell = collectionView.cellForItem(at: indexPath)! as! ItensCollectionCell
        selectedCell.lblView.backgroundColor = UIColor(patternImage: UIImage(named: "bluehori.jpg")!)
        selectedCell.lblHour.backgroundColor = UIColor(patternImage: UIImage(named: "bluehori.jpg")!)
       
        loadItens()
        
       
//        self.collectionSchedule.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath)! as! ItensCollectionCell
        selectedCell.lblView.backgroundColor = UIColor.gray
    }

    
    @IBAction func btnNew(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle:  nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewTask") as! Newtask
        self.present(vc, animated: true, completion: nil)
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
