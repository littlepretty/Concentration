//
//  Concentration.swift
//  Concentration
//
//  Created by Jiaqi Yan on 12/8/17.
//  Copyright © 2017 IIT. All rights reserved.
//

import Foundation

class Concentration {
    private(set) var cards = Array<Card>()
    //: Optional type tell us whether there are only 1 card to be matched with chosen card
    //: Note: usage of *Computed Property* with both set/get
    private var indexOfOneAndOnlyFaceUpCard: Int! {
        get {
            //: Note: usage of Closure in filter
            let faceUpIndices = cards.indices.filter { cards[$0].isFaceUp == true }
            //: Note: usage of extended property oneAndOnly
            return faceUpIndices.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    //: Track seen cards for calculating penaly
    private var mismatchedCards = Dictionary<Int, Bool>()
    
    private(set) var score = 0 //: score of the game
    private(set) var flipCount = 0 //: #flips done by the user
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard: chosen index \(index) not in cards")
        if cards[index].isMatched {return} //: ignore matched cards
        if let matchIndex = indexOfOneAndOnlyFaceUpCard {
            if index != matchIndex {
                if cards[index] == cards[matchIndex] {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                    mismatchedCards[index] = false
                    mismatchedCards[matchIndex] = false
                    score += 2
                } else { //: penalty ormark a mismatched pair
                    if mismatchedCards[index] == true {score -= 1}
                    if mismatchedCards[matchIndex] == true {score -= 1}
                    mismatchedCards[index] = true
                    mismatchedCards[matchIndex] = true
                }
                //: either match or non-match, we don't have the one and only waiting-to-be-matched card
                //: since indexOfOneAndOnlyFaceUpCard is computed everytime, no need to set it to nil here
                flipCount += 1
            } //: Don't increase flip count if re-choose card at matchIndex
        } else {
            indexOfOneAndOnlyFaceUpCard = index // now we have the one and only card, call the set func
            flipCount += 1
        }
        cards[index].isFaceUp = true
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init: number of pairs of cards must > 0")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card] //: create a pair
        }
        //: Shuffle the cards using [Fisher–Yates shuffle](https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle)
        for i in cards.indices {
            mismatchedCards[i] = false
            //: Note: another usage of random number extension to Int
            let j = (cards.count - i).arc4random + i
            cards.swapAt(i, j)
        }
    }
}

//: Extend type Int to return a random number between [0, self), for get a random index of size self
extension Int {
    var arc4random: Int {
        get {
            if self > 0 { return Int(arc4random_uniform(UInt32(self))) }
            else if self < 0 { return -Int(arc4random_uniform(UInt32(-self)))}
            else { return 0}
        }
    }
}
//: Extend type Collection(e.g. array, string) to return one and the only one element
extension Collection {
    var oneAndOnly: Element! {
        return count == 1 ? first : nil //: count and first are all property of Collection
    }
}
