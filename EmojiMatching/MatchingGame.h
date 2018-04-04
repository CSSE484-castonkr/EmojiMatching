//
//  MatchingGame.h
//  EmojiMatching
//
//  Created by Kiana Caston on 4/3/18.
//  Copyright © 2018 Kiana Caston. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CardState) {
    CardStateHidden,
    CardStateShown,
    CardStateRemoved
};

typedef NS_ENUM(NSInteger, GameState) {
    GameStateNoSelection,
    GameStateOneSelection
};

@interface MatchingGame : NSObject {
    CardState _cardStates[20];
}

@property (nonatomic) NSInteger numPairs;
@property (nonatomic) NSArray* cards;
@property (nonatomic) NSString* cardBack;
@property (nonatomic) CardState cardState;
@property (nonatomic) GameState gameState;
@property (nonatomic) NSInteger firstClick;

- (id) initWithNumPairs: (NSInteger) numPairs;
- (BOOL) pressedCard: (NSInteger) atIndex;
- (void) checkMatch: (NSInteger) firstIndex secondIndex: (NSInteger)secondIndex;
- (CardState) getCardState: (NSInteger) atIndex;
- (NSString*) getCardAtIndex: (NSInteger) atIndex;
- (NSString*) getBoardString;

@end
