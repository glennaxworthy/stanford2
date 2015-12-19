//
//  CardGameViewController.m
//  Project2
//
//  Created by Glenn Axworthy on 8/25/15.
//  Copyright (c) 2015 Glenn Axworthy. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardGame.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()

@property (strong, nonatomic) CardDeck *cardDeck;
@property (strong, nonatomic) CardGame *cardGame;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) NSMutableArray *chosenCards;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation CardGameViewController

- (CardDeck *)cardDeck
{
    if (!_cardDeck )
        _cardDeck = [[PlayingCardDeck alloc] init];

    return _cardDeck;
}

- (CardGame *)cardGame
{
    if (!_cardGame)
    {
        unsigned count = (unsigned) [self.cardButtons count];
        _cardGame = [[CardGame alloc] initWithDeck:self.cardDeck cards:count];
    }

    return _cardGame;
}

- (UIImage *)cardImage:(Card *)card
{
    return [UIImage imageNamed:(card.chosen ? @"cardfront" : @"cardback")];
}

- (NSString *)cardTitle:(Card *)card
{
    return card.chosen ? card.contents : @"";
}

- (IBAction)cardTouched:(id)sender
{
    int score = self.cardGame.score;
    unsigned index = (unsigned) [self.cardButtons indexOfObject:sender];
    Card *card = [self.cardGame cardAtIndex:index];
    [self.cardGame chooseCardAtIndex:index];
    [self updateUI];

    NSString *result = @"";
    int delta = self.cardGame.score - score;

    if (!card.chosen)
        [self.chosenCards removeObject:card];
    else
    {
        [self.chosenCards addObject:card];
        if ([self.chosenCards count] == 1)
            // first and only card chosen
            result = [NSString stringWithFormat:@"Chose %@ for %d points", card.contents, delta];
        else if (card.matched)
        {
            result = @"Matched ";

            for (Card *chosen in self.chosenCards)
                if (chosen.matched)
                    result = [NSString stringWithFormat:@"%@ %@", result, chosen.contents];

            result = [NSString stringWithFormat:@"%@ for %d points", result, delta];
            [self.chosenCards removeAllObjects];
        }
        else
        {
            // card mismatch
            result = @"Mismatched ";

            for (Card *chosen in self.chosenCards)
                result = [NSString stringWithFormat:@"%@ %@", result, chosen.contents];
        
            result = [NSString stringWithFormat:@"%@ for %d penalty", result, delta];
            [self.chosenCards removeAllObjects];
            [self.chosenCards addObject:card];
        }
    }

    self.resultLabel.text = result;
    self.modeControl.enabled = NO;
}

- (NSMutableArray *)chosenCards
{
    if (!_chosenCards)
        _chosenCards = [[NSMutableArray alloc] init];

    return _chosenCards;
}

- (IBAction)modeChanged:(id)sender
{
    [self newGame];
    self.cardGame.mode = (unsigned) self.modeControl.selectedSegmentIndex + 2;
}

- (void)newGame
{
    unsigned count = (unsigned) [self.cardButtons count];
    [self.cardGame resetWithDeck:self.cardDeck cards:count];
    [self updateUI];

    [self.chosenCards removeAllObjects];
    self.modeControl.enabled = YES;
    self.resultLabel.text = nil;
}

- (IBAction)newGameTouched:(id)sender
{
    [self newGame];
}

- (void) updateUI
{
    for (UIButton *button in self.cardButtons)
    {
        unsigned index = (unsigned) [self.cardButtons indexOfObject:button];
        Card *card = [self.cardGame cardAtIndex:index];
        UIImage *image = [self cardImage:card];
        NSString *title = [self cardTitle:card];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.enabled = !card.matched;
    }

    NSString *text = [NSString stringWithFormat:@"Score: %d", self.cardGame.score];
    [self.scoreLabel setText:text];
}

- (void) viewDidLoad
{
    [self updateUI];
}

@end
