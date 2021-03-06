//
//  PlayingCard.m
//  Project2
//
//  Created by Glenn Axworthy on 8/26/15.
//  Copyright (c) 2015 Glenn Axworthy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

- (NSString *)contents
{
    NSString *rankString = (NSString *)[[PlayingCard rankStrings] objectAtIndex:self.rank];
    return [NSString stringWithFormat:@"%@%@", rankString, self.suit];
}

- (unsigned)matches:(Card *)card
{
    unsigned score = 0;
    if ([card isKindOfClass:[PlayingCard class]])
    {
        PlayingCard *playingCard = (PlayingCard *)card;
        if (self.rank == playingCard.rank)
            score += 1;
        if ([self.suit isEqualToString:playingCard.suit])
            score += 4;
    }

    return score;
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard suitStrings] containsObject:suit])
        _suit = suit;
}

+ (NSArray *)suitStrings
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

@end
