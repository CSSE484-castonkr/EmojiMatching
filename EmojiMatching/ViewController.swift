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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(game.description)
        updateView()
    }
    
    @IBAction func pressedNewGame(_ sender: Any) {
        game = MatchingGame(numPairs: 10)
        updateView()
    }
    
    @IBAction func pressedCard(_ sender: Any) {
    }
    
    func updateView() {
        for i in 0..<cards.count {
            switch game.cardStates[i] {
            case .hidden:
                cards[i].setTitle(String(game.cardBack), for: .normal)
            case .shown:
                cards[i].setTitle(String(game.cards[i]), for: .normal)
            case .removed:
                cards[i].setTitle("", for: .normal)
                cards[i].isEnabled = false
            }
        }
    }
    
    
    
    
    
   

    
    

}

