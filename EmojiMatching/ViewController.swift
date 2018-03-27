//
//  ViewController.swift
//  EmojiMatching
//
//  Created by Kiana Caston on 3/25/18.
//  Copyright © 2018 Kiana Caston. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cards: [UIButton]!
    
    var game = MatchingGame(numPairs: 10)
    var blockingUiIntentionally = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(game)
        updateView()
    }
    
    @IBAction func pressedNewGame(_ sender: Any) {
        game = MatchingGame(numPairs: 10)
        blockingUiIntentionally = false
        print(game)
        updateView()
    }
    
    @IBAction func pressedCard(_ sender: Any) {
        if blockingUiIntentionally {
            return
        }
        
        
        let card = sender as! UIButton
        let pair = game.pressedCard(atIndex: card.tag)
        updateView()
        if (pair) {
            blockingUiIntentionally = true
            delay(1.2) {
                self.updateView()
                self.blockingUiIntentionally = false
            }
        }
    }
    
    func updateView() {
        for i in 0..<cards.count {
            switch game.cardStates[i] {
            case .hidden:
                cards[i].setTitle(String(game.cardBack), for: .normal)
                cards[i].isEnabled = true
            case .shown:
                cards[i].setTitle(String(game.cards[i]), for: .normal)
            case .removed:
                cards[i].setTitle("", for: .normal)
                cards[i].isEnabled = false
            }
        }
    }
    
    
    
    
    
   

    
    

}

