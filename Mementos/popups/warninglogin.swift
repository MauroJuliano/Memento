//
//  warninglogin.swift
//  Mementos
//
//  Created by Lestad on 05/07/20.
//  Copyright © 2020 Lestad. All rights reserved.
//

import Foundation
import UIKit

class popviewcontroller: UIViewController {
    
    //Pop up to say the user have some issue in password or email
    
    @IBOutlet weak var btnokay: RoundedButton!
    @IBOutlet weak var popwarning: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        popwarning.backgroundColor = UIColor.white
        
        
    }
    @IBAction func btnokay(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
