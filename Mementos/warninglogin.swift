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
    
    
    @IBOutlet weak var btnokay: RoundedButton!
    @IBOutlet weak var popwarning: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        popwarning.backgroundColor = UIColor(patternImage: UIImage(named: "blue.jpg")!)
        
        
    }
    @IBAction func btnokay(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
