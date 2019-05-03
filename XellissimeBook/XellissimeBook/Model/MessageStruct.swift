//
//  MessageStruct.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 03/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation

struct Message {
    var messageFrom: String // userIosId from User who sents first message
    var messageTo: String // userIosId from User who receives message
    var messageText : String
    var messageData: Data?
}
