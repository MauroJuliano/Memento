//
//  List.swift
//  Mementos
//
//  Created by Lestad on 06/07/20.
//  Copyright © 2020 Lestad. All rights reserved.
//

import Foundation
import UIKit


class Listaa: NSObject {
    var Name: String!
    var Listas: String!
    var Lista: String!
    var AnotherList: String!
    var Itens: String!
    var Date: String!
    var Hour: String!
}

class todo: NSObject {
    var Lista: String!
    var Date: String!
    var Hour: String!
    var Itens: String!
}

class users {
var email: String
var username: String
var userid: String

    init(usernameString: String, emailString: String, UserIDString: String) {
    username = usernameString
    email = emailString
    userid = UserIDString
}
}

class usersAlert: NSObject {
var Alerta: String!
var date: String!
var userid: String!
var hour: String!
var lista: String!
}

class users2: NSObject {
var email: String!
var name: String!
var userID: String!
}
