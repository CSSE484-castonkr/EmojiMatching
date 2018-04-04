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
    
    var game: MatchingGame! = MatchingGame(numPairs: 10)
    var blockingUiIntentionally = false
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(game.getBoardString())
        updateView()
    }
    
    @IBAction func pressedNewGame(_ sender: Any) {
        game = MatchingGame(numPairs: 10)
        blockingUiIntentionally = false
        print(game.getBoardString())
        updateView()
    }
    
    @IBAction func pressedCard(_ sender: Any) {
        if blockingUiIntentionally {
            return
        }
        
        let card = sender as! UIButton
        let pair = game.pressedCard(card.tag)
        updateView()
        if (pair) {
            blockingUiIntentionally = true
            delay(1.2) {
                self.game.checkMatch(self.game.firstClick, secondIndex: card.tag)
                self.updateView()
                self.blockingUiIntentionally = false
            }
        }
    }
    
    func updateView() {
        for i in 0..<cards.count {
            switch game.getCardState(i) {
            case .hidden:
                cards[i].setTitle(game.cardBack, for: .normal)
                cards[i].isEnabled = true
            case .shown:
                cards[i].setTitle(game.getCardAt(i), for: .normal)
            case .removed:
                cards[i].setTitle("", for: .normal)
                cards[i].isEnabled = false
            }
    }
}

}

