//
//  MatchingGame.swift
//  Emoji Matching Exam
//
//  Code snippets and free hints


import Foundation

// Here are the card backs and emoji symbols you shoud use.
let allCardBacks = Array("🎆🎇🌈🌅🌇🌉🌃🌄⛺⛲🚢🌌🌋🗽")
let allEmojiCharacters = Array("🚁🐴🐇🐢🐱🐌🐒🐞🐫🐠🐬🐩🐶🐰🐼⛄🌸⛅🐸🐳❄❤🐝🌺🌼🌽🍌🍎🍡🏡🌻🍉🍒🍦👠🐧👛🐛🐘🐨😃🐻🐹🐲🐊🐙")


/* ------ Code snippet #1 --------- */
// Helper method to randomize the order of an Array. See usage later.  Copied from:
// http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
extension Array {
  mutating func shuffle() {
    for i in 0..<(count - 1) {
      let j = Int(arc4random_uniform(UInt32(count - i))) + i
      self.swapAt(i, j)
    }
  }
}

/* ------ Code snippet #2 --------- */
// Helper method to create a time delay. Copied from:
// http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861
// See answer with most votes for usage examples (VERY easy) delay(1.2) { ... }
// Copy this snippet to your ViewController file (not realy useful in the model).
// This is *one* way to solve the 1.2 second delay requirement.
func delay(_ delay:Double, closure:@escaping ()->()) {
  let when = DispatchTime.now() + delay
  DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

/* ------ Code snippet #3 --------- */
// Examples of getting random cards from the emoji symbol array (could go into init)
var cards : [Character]
var cardBack : Character

// Randomly select emojiSymbols
var emojiSymbolsUsed = [Character]()
while emojiSymbolsUsed.count < 4 {
  let index = Int(arc4random_uniform(UInt32(allEmojiCharacters.count)))
  let symbol = allEmojiCharacters[index]
  if !emojiSymbolsUsed.contains(symbol) {
    emojiSymbolsUsed.append(symbol)
  }
}
cards = emojiSymbolsUsed + emojiSymbolsUsed
cards.shuffle()

// Randomly select a card back for this round
var index = Int(arc4random_uniform(UInt32(allCardBacks.count)))
cardBack = allCardBacks[index]


// ------------------------------------------------
//  Matching Game Logic
// ------------------------------------------------

class MatchingGame: CustomStringConvertible {
    enum CardState: String {
        case hidden = "Hidden"
        case shown = "Shown"
        case removed = "Removed"
    }
    
    enum GameState {
        case noSelection
        case oneSelection(Int)
        case turnComplete(Int, Int)
        
        func simpleDescription() -> String {
            switch self{
            case .noSelection:
                return "Waiting for first selection"
            case .oneSelection(let firstClick):
                return "Waiting for second selection: first click=\(firstClick)"
            case .turnComplete(let firstClick, let secondClick):
                return "Turn complete: first click=\(firstClick) second click=\(secondClick)"
            }
        }
    }
    
    let allCardBacks = Array("🎆🎇🌈🌅🌇🌉🌃🌄⛺⛲🚢🌌🌋🗽")
    let allEmojiCharacters = Array("🚁🐴🐇🐢🐱🐌🐒🐞🐫🐠🐬🐩🐶🐰🐼⛄🌸⛅🐸🐳❄❤🐝🌺🌼🌽🍌🍎🍡🏡🌻🍉🍒🍦👠🐧👛🐛🐘🐨😃🐻🐹🐲🐊🐙")
    let numPairs: Int;
    
    var cards: [Character]
    var cardBack : Character
    var cardStates: [CardState]
    var gameState: GameState
    
    init(numPairs: Int) {
        self.numPairs = numPairs
        self.cardStates = [CardState](repeating: CardState.hidden, count: 2 * numPairs)
        self.gameState = GameState.noSelection
        
        // Randomly select emojiSymbols
        var emojiSymbolsUsed = [Character]()
        while emojiSymbolsUsed.count < self.numPairs {
            let index = Int(arc4random_uniform(UInt32(allEmojiCharacters.count)))
            let symbol = allEmojiCharacters[index]
            if !emojiSymbolsUsed.contains(symbol) {
                emojiSymbolsUsed.append(symbol)
            }
        }
        self.cards = emojiSymbolsUsed + emojiSymbolsUsed
        self.cards.shuffle()
        
        // Randomly select a card back for this round
        let index = Int(arc4random_uniform(UInt32(allCardBacks.count)))
        self.cardBack = allCardBacks[index]
        
    }
    
    func pressedCard(atIndex: Int){
        switch self.gameState {
        case .noSelection:
            self.gameState = GameState.oneSelection(atIndex)
        case .oneSelection(let firstClick):
            self.gameState = GameState.turnComplete(firstClick, atIndex)
        case .turnComplete(_, _):
            break
        }
        
        if (self.cardStates[atIndex] == .hidden){
            self.cardStates[atIndex] = .shown
        }
    }
    
    func startNewTurn() {
        switch self.gameState {
        case .noSelection:
            break
        case .oneSelection(_):
            break
        case .turnComplete(let firstClick, let secondClick):
            if (self.cards[firstClick] == self.cards[secondClick]) {
                self.cardStates[firstClick] = .removed
                self.cardStates[secondClick] = .removed
            } else{
                self.cardStates[firstClick] = .hidden
                self.cardStates[secondClick] = .hidden
            }
            self.gameState = .noSelection
        }
    }
    
    func getGameString() -> String{
        var gameString = ""
        var rowCount = 0
        for i in 0..<self.cards.count{
            if rowCount > 3{
                gameString += "\n"
                rowCount = 0
            }
            gameString.append(self.cards[i])
            rowCount += 1
        }
        return gameString
        
    }
    
    var description: String{
        return getGameString()
    }
    
}



// ------------------------------------------------
//  Completely optional test code if you choose to
//  use a Playground to develop the model object.
// ------------------------------------------------

// Real game to see random values
var game = MatchingGame(numPairs: 10)
game.cards
game.cards[0]
game.cardStates
game.cardStates[0].rawValue
game.cardBack
game.gameState.simpleDescription()
game.description

// Playing with non-random cards (better for testing)
game.cards = Array("01234567890123456789")

// Making a match
game.cards[2]
game.cards[12]
game.cardStates[2].rawValue
game.cardStates[12].rawValue
game.gameState.simpleDescription()
game.pressedCard(atIndex: 2)
game.cardStates[2].rawValue
game.cardStates[12].rawValue
game.gameState.simpleDescription()
game.pressedCard(atIndex: 12)
game.cardStates[2].rawValue
game.cardStates[12].rawValue
game.gameState.simpleDescription()
game.startNewTurn()
game.cardStates[2].rawValue
game.cardStates[12].rawValue
game.gameState.simpleDescription()

// Non-match
game.cards[1]
game.cards[15]
game.cardStates[1].rawValue
game.cardStates[15].rawValue
game.gameState.simpleDescription()
game.pressedCard(atIndex: 1)
game.cardStates[1].rawValue
game.cardStates[15].rawValue
game.gameState.simpleDescription()
game.pressedCard(atIndex: 15)
game.cardStates[1].rawValue
game.cardStates[15].rawValue
game.gameState.simpleDescription()
game.startNewTurn()
game.cardStates[1].rawValue
game.cardStates[15].rawValue
game.gameState.simpleDescription()

