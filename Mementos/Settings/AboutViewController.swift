//
//  AboutViewController.swift
//  Mementos
//
//  Created by Lestad on 21/07/20.
//  Copyright © 2020 Lestad. All rights reserved.
//

import UIKit
import WebKit
class AboutViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webkit: WKWebView!
    var dataReceive = ""
    @IBOutlet weak var activity: UIActivityIndicatorView!
    override func loadView() {

      
        webkit = WKWebView()
        webkit.navigationDelegate = self
        view = webkit
    }
    override func viewDidLoad() {
        print(self.dataReceive)
        connection()
//        let url = URL(string: "https://sardothian.webnode.com/sobre-nos/")!
//        webkit.load(URLRequest(url: url))
//        webkit.allowsBackForwardNavigationGestures = true
        
        super.viewDidLoad()
        
        
    }
    func connection(){
        if dataReceive == "About"{
            let url = URL(string: "https://sardothian.webnode.com/sobre-nos/")!
                   webkit.load(URLRequest(url: url))
                   webkit.allowsBackForwardNavigationGestures = true
        }else if dataReceive == "Support"{
            let url = URL(string: "https://sardothian.webnode.com/contato/")!
            webkit.load(URLRequest(url: url))
            webkit.allowsBackForwardNavigationGestures = true
        }
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
