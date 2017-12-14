//
//  Card.swift
//  Concentration
//
//  Created by Jiaqi Yan on 12/8/17.
//  Copyright © 2017 IIT. All rights reserved.
//

import Foundation

struct Card: Hashable {
    //: Note: let Card conform to protocol Hashable s.t. we can use it as key and compare two cards.
    //: Need to implement one property(hashValue) and one method(==)
    var hashValue: Int { return identifier }
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    //: Note: both boolean status should be public
    var isFaceUp = false
    var isMatched = false
    
    //: Use static var/func to generate unique ids
    //: Because card is Hashable, we can make identifier private
    private var identifier: Int
    
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }

    init() { self.identifier = Card.getUniqueIdentifier() }
}
