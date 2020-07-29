//
//  Newtask.swift
//  Mementos
//
//  Created by Lestad on 02/07/20.
//  Copyright © 2020 Lestad. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class Newtask: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var BSave: RoundedButton!
    @IBOutlet weak var titleof: UITextField!
    @IBOutlet weak var TxtHour: UITextField!
    @IBOutlet weak var TxtDate: UITextField!
    @IBOutlet weak var TxtType: UITextField!
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Btnpin: RoundedButton!
    var itens = [String]()
    var ref: DatabaseReference!
    var tag = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        placholders()
        BSave.backgroundColor = UIColor(patternImage: UIImage(named: "blue.jpg")!)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blue3.jpg")!)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func placholders(){
        titleof.attributedPlaceholder = NSAttributedString(string: "Title of",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        TxtHour.attributedPlaceholder = NSAttributedString(string: "Hour",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        TxtDate.attributedPlaceholder = NSAttributedString(string: "Date",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        TxtType.attributedPlaceholder = NSAttributedString(string: "Itens",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellView", for: indexPath)
        cell.textLabel?.text = itens[indexPath.row]
        cell.backgroundColor = UIColor.clear
        let joined = itens.joined(separator: ", ")
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           let delete = deleteAction(at: indexPath)
           return UISwipeActionsConfiguration(actions: [delete])
       }
       func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
           
           let action = UIContextualAction(style: .destructive, title: "Delete") {(action, view, completion) in
            
            if let index = self.itens.firstIndex(of: self.itens[indexPath.row]) {
                self.itens.remove(at: index)
                self.tableView.reloadData()
                       }
                           }
               self.tableView.reloadData()
                       
           action.image = #imageLiteral(resourceName: "trash.png")
           action.backgroundColor = UIColor(patternImage: UIImage(named: "blue.jpg")!)
           return action
       }
    
    @IBAction func btnTag(_ sender: Any) {
        
        self.tag = "Alert"
        
    }
    
    @IBAction func Btnpin(_ sender: Any) {
        itens.append(self.TxtType.text!)
        let joined = itens.joined(separator: ", ")
        TxtType.clearButtonMode = .whileEditing
        self.tableView.reloadData()
    }
    @IBAction func Bsave(_ sender: Any) {
        self.ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        let usersReference = self.ref.child("users").child("Listas")
             print(usersReference.description())
        

        
        let type = self.titleof.text!
        
        let newReference = usersReference.child(uid).child("\(type)")
        newReference.setValue(["Hour": self.TxtHour.text!, "Date": self.TxtDate.text!, "Itens": self.itens, "Lista": self.titleof.text!, "userid": uid])
        
        if self.tag != ""{
            newReference.setValue(["Hour": self.TxtHour.text!, "Date": self.TxtDate.text!, "Itens": self.itens, "Lista": self.titleof.text!, "userid": uid, "Alerta":self.tag])
        }
        self.dismiss(animated: true, completion: nil)
    
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
