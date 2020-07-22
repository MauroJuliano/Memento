//
//  Firebase.swift
//  Mementos
//
//  Created by Lestad on 03/07/20.
//  Copyright © 2020 Lestad. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager {
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user{
                print(user)
                completionBlock(true)
            } else{
                completionBlock(false)
            }
        }
    }
}
