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
    // Track seen cards for calculating penaly
    var mismatchedCards = Dictionary<Int, Bool>()
    
    var score = 0 // score of the game
    var flipCount = 0 // #flips done by the user
    
    func chooseCard(at index: Int) {
        if cards[index].isMatched {return} // ignore matched cards
        if let matchIndex = indexOfOneAndOnlyFaceUpCard {
            if index != matchIndex {
                if cards[index].identifier == cards[matchIndex].identifier {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                    mismatchedCards[index] = false
                    mismatchedCards[matchIndex] = false
                    score += 2
                } else { // penalty ormark a mismatched pair
                    if mismatchedCards[index] == true {score -= 1}
                    if mismatchedCards[matchIndex] == true {score -= 1}
                    mismatchedCards[index] = true
                    mismatchedCards[matchIndex] = true
                }
                // either match or non-match, we don't have the one and only waiting-to-be-matched card
                indexOfOneAndOnlyFaceUpCard = nil
                flipCount += 1
            } // Don't increase flip count if re-choose card at matchIndex
        } else {
            for i in cards.indices {
                cards[i].isFaceUp = false
            }
            indexOfOneAndOnlyFaceUpCard = index // now we have the one and only card
            flipCount += 1
        }
        cards[index].isFaceUp = true
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card] // create a pair
        }
        // Shuffle the cards using Fisher–Yates shuffle: see https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
        for i in cards.indices {
            mismatchedCards[i] = false
            let j = Int(arc4random_uniform(UInt32(cards.count - i))) + i
            cards.swapAt(i, j)
        }
    }
}
