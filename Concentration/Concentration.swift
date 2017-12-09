//
//  Concentration.swift
//  Concentration
//
//  Created by Jiaqi Yan on 12/8/17.
//  Copyright © 2017 IIT. All rights reserved.
//

import Foundation

class Concentration {
    var cards = Array<Card>()
    // Optional type tell us whether there are only 1 card to be matched with chosen card
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(at index: Int) {
        if cards[index].isMatched {
            return // ignore matched cards
        }
        if let matchIndex = indexOfOneAndOnlyFaceUpCard {
            if index != matchIndex {
                if cards[index].identifier == cards[matchIndex].identifier {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                }
                // either match or non-match, we don't have the one and only waiting-to-be-matched card
                indexOfOneAndOnlyFaceUpCard = nil
            }
        } else {
            for i in cards.indices {
                cards[i].isFaceUp = false
            }
            indexOfOneAndOnlyFaceUpCard = index
        }
        cards[index].isFaceUp = true
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card] // create a pair
        }
        // TODO: shuffle the cards
    }
}
