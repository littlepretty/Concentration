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
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    // Give emojis to the buttons
    var emojiChoices = ["👻", "🦇", "😈", "🎃", "🍏", "🍭", "🙀", "🍩"]
    var emojiDict = Dictionary<Int, String>()
    
    @IBAction func touchCardButton(_ sender: UIButton) {
        flipCount += 1
        if let cardIndex = cardButtons.index(of: sender) {
            game.chooseCard(at: cardIndex)
            updateView()
        }
    }
    
    func emoji(for card: Card) -> String {
        if emojiDict[card.identifier] == nil {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emojiDict[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emojiDict[card.identifier] ?? "?"
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
