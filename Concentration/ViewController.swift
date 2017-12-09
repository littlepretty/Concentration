//
//  ViewController.swift
//  Concentration
//
//  Created by Jiaqi Yan on 12/8/17.
//  Copyright © 2017 IIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // Collection of UIButtons
    @IBOutlet var cardButtons: [UIButton]!
    
    // Automatically sync flipCountLabel with UILabel
    @IBOutlet weak var flipCountLabel: UILabel!
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    // Talk to the Model
    // Since cardButtons needs to be init first, use keyword "lazy" here
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    // Give emojis to the buttons
    var theme: Int?
    var emojiChoices = [["👻", "🦇", "😈", "🎃", "👺", "🙀", "🐉", "👹", "🤡", "☠️", "👽"],
                        ["🍏", "🍇", "🍉", "🍋", "🍊", "🥥", "🥝", "🍓", "🍍", "🍒", "🍑"],
                        ["🍭", "🍩", "🍪", "🍬", "🍫", "🎂", "🍰", "🍥", "🍔", "🍟", "🍕"],
                        ["🐶", "🦄", "🦖", "🐢", "🐝", "🐛", "🐼", "🦊", "🐊", "🐣", "🐌"]]
    var emojiDict = Dictionary<Int, String>()
    // Lazy initialize the mapping from card id -> emoji
    func emoji(for card: Card) -> String {
        let t = theme ?? Int(arc4random_uniform(UInt32(emojiChoices.count)))
        theme = t // make sure theme is not nil
        if emojiDict[card.identifier] == nil {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices[t].count)))
            emojiDict[card.identifier] = emojiChoices[t].remove(at: randomIndex)
        }
        return emojiDict[card.identifier] ?? "?"
    }
    
    // Start new game or end current game:
    // 1. Reset flip count
    // 2. Regenerate new cards/game
    // 3. Reset card -> emoji relation
    // 4. Update view
    @IBAction func touchNetGameButton(_ sender: UIButton) {
        flipCount = 0
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1 ) / 2)
        if let t = theme {
            for emoji in emojiDict.values {
                emojiChoices[t].append(emoji)
            }
            emojiDict.removeAll()
            theme = nil
        }
        updateView()
    }
    
    @IBAction func touchCardButton(_ sender: UIButton) {
        flipCount += 1
        if let cardIndex = cardButtons.index(of: sender) {
            game.chooseCard(at: cardIndex)
            updateView()
        }
    }
    
    func updateView() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = UIColor.white
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? UIColor.clear : UIColor.orange
            }
        }
    }
}
