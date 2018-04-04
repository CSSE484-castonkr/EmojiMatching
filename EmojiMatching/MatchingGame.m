//
//  MatchingGame.m
//  EmojiMatching
//
//  Created by Kiana Caston on 4/3/18.
//  Copyright © 2018 Kiana Caston. All rights reserved.
//

#import "MatchingGame.h"

@implementation MatchingGame



- (id) initWithNumPairs: (NSInteger) numPairs{
    self = [super init];
    if (self){
        self.numPairs = numPairs;
        NSArray* allCardBacks = [@"🎆,🎇,🌈,🌅,🌇,🌉,🌃,🌄,⛺,⛲,🚢,🌌,🌋,🗽" componentsSeparatedByString:@","];
        NSArray* allEmojiCharacters = [@"🚁,🐴,🐇,🐢,🐱,🐌,🐒,🐞,🐫,🐠,🐬,🐩,🐶,🐰,🐼,⛄,🌸,⛅,🐸,🐳,❄,❤,🐝,🌺,🌼,🌽,🍌,🍎,🍡,🏡,🌻,🍉,🍒,🍦,👠,🐧,👛,🐛,🐘,🐨,😃,🐻,🐹,🐲,🐊,🐙" componentsSeparatedByString:@","];
        
        // Randomly select emojiSymbols
        NSMutableArray* emojiSymbolsUsed = [[NSMutableArray alloc] init];
        while (emojiSymbolsUsed.count < numPairs) {
            NSString* symbol = allEmojiCharacters[arc4random_uniform((UInt32) allEmojiCharacters.count)];
            if (![emojiSymbolsUsed containsObject:symbol]) {
                [emojiSymbolsUsed addObject:symbol];
            }
        }
        [emojiSymbolsUsed addObjectsFromArray:emojiSymbolsUsed];
        // Shuffle the NSMutableArray before converting it to an NSArray.
        for (int i = 0; i < emojiSymbolsUsed.count; ++i) {
            UInt32 j = arc4random_uniform((UInt32) emojiSymbolsUsed.count - i) + i;
            [emojiSymbolsUsed exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
        self.cards = [NSArray arrayWithArray:emojiSymbolsUsed];

        // Randomly select a card back.
        self.cardBack = allCardBacks[arc4random_uniform((UInt32) allCardBacks.count)];

        // Reset cardStates to ensure default values.
        for (int i = 0; i < self.cards.count; ++i) {
            _cardStates[i] = CardStateHidden;
        }
    }

    return self;
}



- (CardState) getCardState: (NSInteger) atIndex {
    return _cardStates[atIndex];
}

- (BOOL) pressedCard: (NSInteger) atIndex {
    switch(self.gameState){
        case GameStateNoSelection:
            self.gameState = GameStateOneSelection;
            self.firstClick = atIndex;
            _cardStates[atIndex] = CardStateShown;
            return NO;
        case GameStateOneSelection:
            if (atIndex != self.firstClick){
                _cardStates[atIndex] = CardStateShown;
                 self.gameState = GameStateNoSelection;
                return YES;
            }
            return NO;
    }
}

- (void) checkMatch: (NSInteger) firstIndex
        secondIndex: (NSInteger)secondIndex {
    if (self.cards[firstIndex] == self.cards[secondIndex]) {
        _cardStates[firstIndex] = CardStateRemoved;
        _cardStates[secondIndex] = CardStateRemoved;
    } else{
        _cardStates[firstIndex] = CardStateHidden;
        _cardStates[secondIndex] = CardStateHidden;
    }
}

- (NSString*) getCardAtIndex: (NSInteger) atIndex {
    return self.cards[atIndex];
}

- (NSString*) getBoardString {
    return [NSString stringWithFormat:@"%@%@%@%@%@",
            [self getBoardStringCol1:0 Col2:1 Col3:2 Col4:3],
            [self getBoardStringCol1:4 Col2:5 Col3:6 Col4:7],
            [self getBoardStringCol1:8 Col2:9 Col3:10 Col4:11],
            [self getBoardStringCol1:12 Col2:13 Col3:14 Col4:15],
            [self getBoardStringCol1:16 Col2:17 Col3:18 Col4:19]];
}

- (NSString*) getBoardStringCol1: (int) index1
                            Col2: (int) index2
                            Col3: (int) index3
                            Col4: (int) index4 {
    return [NSString stringWithFormat:@"%@%@%@%@\n",
            self.cards[index1],
            self.cards[index2],
            self.cards[index3],
            self.cards[index4]];
}

@end
