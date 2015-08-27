//
//  ATMPlainCustomButton.m
//  AtmMoney
//
//  Created by Dimitris C. on 7/7/15.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import "ATMPlainCustomButton.h"

@implementation ATMPlainCustomButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    self.backgroundColor = (highlighted) ? self.selectedBackgroundColor : self.normalBackgroundColor;
    [self setNeedsDisplay];
}

@end
