//
//  ViewController.swift
//  Concentration
//
//  Created by Jiaqi Yan on 12/8/17.
//  Copyright © 2017 IIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //: Collection of UIButtons
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var flipCountLabel: UILabel! {
        didSet { updateFlipCountLabel() } //: Draw label at app launch
    }
    
    //: Note: Make flipCountLabel with fancy font
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.strokeWidth: 5.0,
            NSAttributedStringKey.strokeColor: UIColor.orange
        ]
        let attributed_label = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributed_label
    }

    //: Note: usage of *Computed Property*
    private var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2 /// Note: get-only property don't need {} at all
    }
    // Talk to the Model
    //: Since cardButtons needs to be init first, use keyword "lazy" here
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    //: Give emojis to the buttons
    private var theme: Int!
    private var emojiChoices = [["👻", "🦇", "😈", "🎃", "👺", "🙀", "🐉", "👹", "🤡", "☠️", "👽"],
                                ["🍏", "🍇", "🍉", "🍋", "🍊", "🥥", "🥝", "🍓", "🍍", "🍒", "🍑"],
                                ["🍭", "🍩", "🍪", "🍬", "🍫", "🎂", "🍰", "🍥", "🍔", "🍟", "🍕"],
                                ["🐶", "🦄", "🦖", "🐢", "🐝", "🐛", "🐼", "🦊", "🐊", "🐣", "🐌"]]
    //: Note: after making Card conform to Hashable, can use Card as key
    private var emojiDict = Dictionary<Card, String>()
    //: Lazy initialize the mapping from card id -> emoji
    private func emoji(for card: Card) -> String {
        /// Note: usage of extension to type Int to
        /// replace "let t = theme ?? Int(arc4random_uniform(UInt32(emojiChoices.count)))"
        let t = theme ?? emojiChoices.count.arc4random
        theme = t // make sure theme is not nil
        if emojiDict[card] == nil {
            /// Note: usage of extension to type Int
            let randomIndex = emojiChoices[t].count.arc4random
            emojiDict[card] = emojiChoices[t].remove(at: randomIndex)
        }
        return emojiDict[card] ?? "?"
    }
    
    /**
      Start new game or end current game:
         - 1. Reset flip count
         - 2. Regenerate new cards/game
         - 3. Reset card -> emoji relation after put emoji back to emojiChoices[t]
         - 4. Update view
     */
    @IBAction private func touchNetGameButton(_ sender: UIButton) {
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
    
    @IBAction private func touchCardButton(_ sender: UIButton) {
        if let cardIndex = cardButtons.index(of: sender) {
            game.chooseCard(at: cardIndex)
            updateView()
        }
    }
    
    private func updateView() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp || card.isMatched {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = UIColor.white
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = UIColor.orange
            }
        }
        scoreLabel.text = "Score: \(game.score)"
        updateFlipCountLabel()
    }
}
